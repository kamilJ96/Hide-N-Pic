//
//  GameStateModel.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 16/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// This class constantly listens for game requests from the server
// Also responsible for creating a game session on the server, and then listening for response
// if we are the ones initiating a game
// Also listens for ending of game when user is inside main game view controller

public class GameStateModel: NSObject {

    // the gameSessionID of the game that we will be/are playing
    private(set) var gameSessionIDdbRef: DatabaseReference!
    
    var pendingGameRequestResponseObserver: GameStateModelObserver?
    var newRequestIDdbRef: DatabaseReference! // the location to write a new game invite request, also the location to delete if you want to cancel
    
    var gameRequestObservers: Array<GameStateModelObserver> = []
    var gameRequests: Array<GameRequest> = [] {
        didSet {
            for observer in gameRequestObservers {
                observer.gameRequestsArrayDidUpdate?()
            }
        }
    }
    
    var myUserID: String! = Auth.auth().currentUser?.uid
    lazy var gameRequestsDBRef: DatabaseReference! = Database.database().reference().child("user_profile").child(myUserID).child("requests")
    
    
    public enum PlayerID {
        case initiatingPlayer
        case invitedPlayer
    }
    
    var myPlayerID: PlayerID?
    var opponentPlayerID: PlayerID?
    
    var opponentPlayerUserID: String!
    
    override init() {
        super.init()
        fetchGameRequestsFromServer()
    }
    
    deinit {
        gameRequestsDBRef.removeAllObservers()
    }
    
    
    func invitePlayer(_ userID: String) -> Void {
        // create new game session on server, store in local var
        let newGameSessionID = Database.database().reference().child("gameSessions").childByAutoId()
        newGameSessionID.child("handshake").setValue("pending")
        gameSessionIDdbRef = newGameSessionID
        
        let myUserID = Auth.auth().currentUser?.uid
        let myName = Auth.auth().currentUser?.displayName
        
        opponentPlayerUserID = userID
        
        newRequestIDdbRef = Database.database().reference().child("user_profile").child(userID).child("requests").childByAutoId()
        newRequestIDdbRef.setValue(["gameSessionID":newGameSessionID.key, "userID": myUserID!, "initiatingPlayerName": myName!])
        
        listenForInviteResponse()
    }
    
    
    func listenForInviteResponse() {
        let _ = gameSessionIDdbRef.child("handshake").observe(.value, with: { (snapshot) in
            if let status = snapshot.value as? String {
                switch status {
                case "declined":
                    self.gameSessionIDdbRef = nil
                    self.opponentPlayerUserID = nil
                    self.pendingGameRequestResponseObserver?.friendDidRespondToInvite!(with: status)
                
                case "accepted":
                    // set up new game
                    self.myPlayerID = .initiatingPlayer
                    self.opponentPlayerID = .invitedPlayer
                    self.pendingGameRequestResponseObserver?.friendDidRespondToInvite!(with: status)
                
                default:
                    break
                }
            } else {
                print("error: GameStateModel->listenForInviteResponse()->snapshot was not handshake status as expected")
            }
            
        })
    }
    
    func cancelInvite() {
        gameSessionIDdbRef.child("handshake").setValue("cancelled")
        newRequestIDdbRef.removeValue()
    }
    
    
    func acceptGameInvite(gameRequest: GameRequest) {
        myPlayerID = .invitedPlayer
        opponentPlayerID = .initiatingPlayer
        gameSessionIDdbRef = gameRequest.gameSessionID
        opponentPlayerUserID = gameRequest.initiatingPlayerUserID
        
        // remove the invite / game request from the server
        gameRequest.dbRef.removeValue()
        
        gameSessionIDdbRef.child("handshake").setValue("accepted")
    }
    
    func declineGameInvite(gameRequest: GameRequest) {
        gameRequest.gameSessionID.child("handshake").setValue("declined")
        gameRequest.dbRef.removeValue()
    }
    
    func fetchGameRequestsFromServer() {
        let myUserID = (Auth.auth().currentUser?.uid)!
        let requestsDBref = Database.database().reference().child("user_profile").child(myUserID).child("requests")
        
        let _ = requestsDBref.observe(.childAdded, with: {
            (Snapshot) in
            
            if let dictionary = Snapshot.value as? NSDictionary {
                
                if let gameSessionIdString = dictionary["gameSessionID"] as? String,
                    let initiatingPlayerName = dictionary["initiatingPlayerName"] as? String,
                    let initiatingPlayerUserID = dictionary["userID"] as? String
                {
                    var gameRequest = GameRequest()
                    gameRequest.initiatingPlayerName = initiatingPlayerName
                    gameRequest.gameSessionID = Database.database().reference().child("gameSessions").child(gameSessionIdString)
                    gameRequest.initiatingPlayerUserID = initiatingPlayerUserID
                    gameRequest.dbRef = Database.database().reference().child("user_profile").child(myUserID).child("requests").child(Snapshot.key)
                    
                    self.gameRequests.append(gameRequest)
                } else {
                    print("error: GameStateModel->fetchGameRequestsFromServer()->childAdded snapshot dictionary did not have values as expected")
                }
            }  else {
                print("error: GameStateModel->fetchGameRequestsFromServer()->childAdded snapshot was not NSDictionary as expected")
            }
        })
        
        
        let _ = requestsDBref.observe(.childRemoved, with: {
            (Snapshot) in
            
            if let dictionary = Snapshot.value as? NSDictionary {
                
                if let gameSessionIdString = dictionary["gameSessionID"] as? String,
                    let initiatingPlayerName = dictionary["initiatingPlayerName"] as? String,
                    let initiatingPlayerUserID = dictionary["userID"] as? String
                {
                    var gameRequest = GameRequest()
                    gameRequest.initiatingPlayerName = initiatingPlayerName
                    gameRequest.gameSessionID = Database.database().reference().child("gameSessions").child(gameSessionIdString)
                    gameRequest.initiatingPlayerUserID = initiatingPlayerUserID
                    gameRequest.dbRef = Database.database().reference().child("user_profile").child(myUserID).child("requests").child(Snapshot.key)
                    
                    // delete our local copy of gameRequest since it has been removed from the server
                    if let indexOfGameRequestInArray = self.gameRequests.index(of: gameRequest) {
                        self.gameRequests.remove(at: indexOfGameRequestInArray)
                    } else {
                        print("error: GameStateModel->fetchGameRequestsFromServer()->could not find childRemoved in our gameRequests array")
                    }
                } else {
                    print("error: GameStateModel->fetchGameRequestsFromServer()->childRemoved snapshot dictionary did not have values as expected")
                }
            } else {
                print("error: GameStateModel->fetchGameRequestsFromServer()->childRemoved snapshot was not NSDictionary as expected")
            }
        })
    }
    
}

@objc
protocol GameStateModelObserver {
    // needs to be able to handle gameEnd message
    @objc optional func gameDidEnd() // might pass in an image with the ending image yknow
    @objc optional func gameRequestsArrayDidUpdate()
    @objc optional func friendDidRespondToInvite(with response: String)
}
