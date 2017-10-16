//
//  GameStateModel.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 16/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import FirebaseDatabase

// This class constantly listens for game requests from the server
// Also responsible for creating a game session on the server, and then listening for response
// if we are the ones initiating a game
// Also listens for ending of game when user is inside main game view controller

class GameStateModel: NSObject {

    var gameSessionID: DatabaseReference!
    
    public enum playerID {
        case initiatingPlayer
        case invitedPlayer
    }
    
    var myPlayerID: playerID
    var opponentPlayerID: playerID
    
    var opponentPlayerUserID: String! // TODO: check chat view controller see how receiving_ID works etc. is it a string as well?
    
    override init() {
    
        // TODO: initialise stuff lol
    }
}

protocol GameStateModelDelegate {
    // needs to be able to handle gameEnd message
}
