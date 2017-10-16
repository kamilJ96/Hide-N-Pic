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
    
    var gameRequest: GameRequest? {
        didSet {
            initiatingPlayerNameLabel?.text = gameRequest!.initiatingPlayerName
        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
