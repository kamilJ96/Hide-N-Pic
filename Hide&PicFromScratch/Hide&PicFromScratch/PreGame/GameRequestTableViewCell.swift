//
//  GameRequestTableViewCell.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 14/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

class GameRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var initiatingPlayerNameLabel: UILabel!
    
    @IBAction func acceptButton(_ sender: Any) {
        
    }
    
    var gameRequest: GameRequest? {
        didSet {
            initiatingPlayerNameLabel?.text = gameRequest!.invitingPlayerName
        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
