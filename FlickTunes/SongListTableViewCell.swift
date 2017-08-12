//
//  SongListTableViewCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/05/21.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class SongListTableViewCell: UITableViewCell {

    @IBOutlet var songJacketImage: UIImageView!
    @IBOutlet var songName: UILabel!
    @IBOutlet var songArtistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
