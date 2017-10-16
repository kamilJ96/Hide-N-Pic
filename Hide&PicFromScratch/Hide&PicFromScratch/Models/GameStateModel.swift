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

class GameStateModel: NSObject {

    private(set) var gameSessionID: DatabaseReference!
    
    var gameRequests: Array<GameRequest> = []
    
    var myUserID: String! = Auth.auth().currentUser?.uid
    lazy var gameRequestsDBRef: DatabaseReference! = Database.database().reference().child("user_profile").child(myUserID).child("requests")
    var gameRequestsObserverID: UInt?
    
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
    func acceptGameInvite(gameRequest: GameRequest) -> Bool {
        // TODO: delete game request from server under myUserId->requests
        // fetch gameSessionID, and other stuff, assign playerIDs etc
        return true
    }
    
    func declineGameInvite(gameRequest: GameRequest) {
        // TODO: set gameSessions->gameSessionID->handshake to declined
        
        // TODO: delete from server
    }
    
    func fetchGameRequestsFromServer() {
        let myUserID = Auth.auth().currentUser?.uid
        let requestsDBref = Database.database().reference().child("user_profile").child(myUserID!).child("requests")
        
        let _ = requestsDBref.observe(.childAdded, with: {
            (Snapshot) in
            // TODO: add all game requests to gameRequests array
            
            if let dictionary = Snapshot.value as? [String: AnyObject] {
                var gameRequest = GameRequest()
                // If you use this setter, app will crash if properties dont match with firebase
                gameRequest.invitingPlayerName = dictionary["initiatingPlayerName"] as? String
                //TODO: fix this line //gameRequest.gameSessionID = Snapshot.key
                
                self.gameRequests.append(gameRequest)
                
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                });
            }
        })
        // TODO: fetch gameRequests on the server and keep listening for additions
        
        // TODO: keep listening to deletions from the server, and update local gameRequests array
    }
    
}

protocol GameStateModelDelegate {
    // needs to be able to handle gameEnd message
    func gameDidEnd() // might pass in an image with the ending image yknow
}
