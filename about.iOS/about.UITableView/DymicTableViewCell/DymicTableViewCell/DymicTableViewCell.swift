//
//  DymicTableViewCell.swift
//  DymicTableViewCell
//
//  Created by burt on 2016. 3. 3..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit

class DymicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tImageView: UIImageView!
    @IBOutlet weak var tLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
