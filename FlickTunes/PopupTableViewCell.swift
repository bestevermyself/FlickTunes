//
//  PopupTableViewCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2018/01/14.
//  Copyright © 2018年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class PopupTableViewCell: UITableViewCell {
    
    /// The reuse identifier for this cell
    static let cellIdentifier = "PopupTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
