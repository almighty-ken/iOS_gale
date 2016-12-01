//
//  FriendTableViewCell.swift
//  Gale
//
//  Created by Ken Cheng on 11/30/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var button_text: UIButton!
    @IBOutlet weak var friend_name: UILabel!
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    @IBAction func accept_req(_ sender: Any) {
        tapAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
