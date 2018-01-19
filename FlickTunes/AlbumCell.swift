//
//  AlbumCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/17.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet var artworkImage: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImage.layer.cornerRadius = 10.0
    }

    func configureWithData(_ data: NSDictionary) {
        if let post = data["post"] as? NSDictionary, let user = post["user"] as? NSDictionary {
            mainLabel.text = user["name"] as? String
            artworkImage.image = UIImage(named: mainLabel.text!.replacingOccurrences(of: " ", with: "_"))
        }
    }

    func changeStylToBlack() {
        artworkImage?.layer.cornerRadius = 30.0
        
        mainLabel.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        mainLabel.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }
}
