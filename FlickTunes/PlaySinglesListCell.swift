//
//  PlaySinglesListCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2018/01/14.
//  Copyright © 2018年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class PlaySinglesListCell: UITableViewCell {

//    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet var songNumber: UILabel!
    
//    @IBOutlet var playCount: UILabel!
//    @IBOutlet var rank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        artistImage.layer.cornerRadius = 10.0
    }
    
    func configureWithData(_ data: NSDictionary) {
        if let post = data["post"] as? NSDictionary, let user = post["user"] as? NSDictionary {
            songName.text = user["name"] as? String
//            artistImage.image = UIImage(named: artistName.text!.replacingOccurrences(of: " ", with: "_"))
        }
    }
    
    func changeStylToBlack() {
//        artistImage?.layer.cornerRadius = 30.0
        songName.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        songName.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }
    
}
