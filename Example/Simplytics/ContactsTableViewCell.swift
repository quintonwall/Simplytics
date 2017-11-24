//
//  ContactsTableViewCell.swift
//  Simplytics_Example
//
//  Created by Quinton Wall on 11/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    public var contactid: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func infoButtonTapped(_ sender: Any) {
        
    }
}
