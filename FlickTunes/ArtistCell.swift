//
//  ArtistCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/12.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        artistImage.layer.cornerRadius = 10.0
    }

    func configureWithData(_ data: NSDictionary) {
        if let post = data["post"] as? NSDictionary, let user = post["user"] as? NSDictionary {
            artistName.text = user["name"] as? String
            artistImage.image = UIImage(named: artistName.text!.replacingOccurrences(of: " ", with: "_"))
        }
    }

    func changeStylToBlack() {
        artistImage?.layer.cornerRadius = 30.0
        artistName.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        artistName.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }
}
