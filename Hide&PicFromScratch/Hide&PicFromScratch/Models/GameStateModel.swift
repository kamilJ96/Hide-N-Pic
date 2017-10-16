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
    private(set) var gameSessionID: DatabaseReference!
    
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
    
    public enum GameState {
        case noGameExists
        case pendingRequestResponse
        case inTheMiddleOfPlaying
        case gameEnded
    }
    
    
    // TODO: go through all scenarios and make sure you're updating this var correctly
    var gameState: GameState = .noGameExists
    
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
    
    
    func invitePlayer(withUserID: String) {
        // TODO: fill out this logic
        // create new game session on server, store in local var
        
        // set server handshake to "pending"
        
        // listen to gameSessions.gameSessionID.handshake for response
        listenForInviteResponse()
    }
    
    func listenForInviteResponse() {
        
        // when player accepts set gameState to inTheMiddleOfPlaying and remove database observer
        
        // stop server gameRequestsObserverID observer (initiated in fetchGameRequestsFromServer())
        
    }
    
    // returns true if successfully invited game invite
    func acceptGameInvite(gameRequest: GameRequest) {
        myPlayerID = .invitedPlayer
        opponentPlayerID = .initiatingPlayer
        gameSessionID = gameRequest.gameSessionID
        //gameRequest.dbRef.removeValue()
        
        gameSessionID.child("handshake").setValue("accepted")
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
                }
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
                    }
                }
            }
        })
    }
    
}

@objc
protocol GameStateModelObserver {
    // needs to be able to handle gameEnd message
    @objc optional func gameDidEnd() // might pass in an image with the ending image yknow
    @objc optional func gameRequestsArrayDidUpdate()
}
