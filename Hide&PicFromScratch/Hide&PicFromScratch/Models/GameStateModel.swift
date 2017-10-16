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
    
    public enum PlayerID {
        case initiatingPlayer
        case invitedPlayer
    }
    
    var myPlayerID: PlayerID?
    var opponentPlayerID: PlayerID?
    
    var opponentPlayerUserID: String! // TODO: check chat view controller see how receiving_ID works etc. is it a string as well?
    
    override init() {
        // TODO: initialise stuff lol
    }
    
    
    // returns true if successfully invited player, false if error in inviting player
    func invitePlayer(withUserID: String) -> Bool {
        // TODO: fill out this logic
        // create new game session on server, store in local var
        
        // listen to gameSessions.gameSessionID.handshake for response
        return true
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
        // TODO: fetch gameRequests on the server and keep listening for additions
        
        // TODO: keep listening to deletions from the server, and update local gameRequests array
    }
    
}

protocol GameStateModelDelegate {
    // needs to be able to handle gameEnd message
    func gameDidEnd() // might pass in an image with the ending image yknow
}
