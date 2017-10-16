//
//  GameRequest.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 14/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class for storing game requests that we have received from another user
struct GameRequest {
    var initiatingPlayerName: String!
    var gameSessionID: DatabaseReference!
    var initiatingPlayerUserID: String!
    var dbRef: DatabaseReference! // the autoID of this game request
}
