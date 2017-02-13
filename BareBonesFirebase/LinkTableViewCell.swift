//
//  LinkTableViewCell.swift
//  BareBonesFirebase
//
//  Created by Annie Tung on 2/13/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
