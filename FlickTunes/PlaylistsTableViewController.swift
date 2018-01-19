//
//  PlaylistsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/14.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

// import Hero
import UIKit
import Foundation
import MediaPlayer
import XLPagerTabStrip

class PlaylistsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var blackTheme = false
    let cellIdentifier = "PlaylistCell"
    var playlistIdList: [String] = []
    var playlistNameList: [String] = []
    var albumArtworkAllImageDic: [Int:[MPMediaItemArtwork]] = [:]
    var itemInfo = IndicatorInfo(title: "View")

    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルセルのレイアウトを登録をする
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
    
        let myPlaylistQuery = MPMediaQuery.playlists()
        let playlists = myPlaylistQuery.collections
        var index = 0
        for playlist in playlists! {
            let persistentId = String(describing: playlist.representativeItem?.persistentID)
            let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName)! as? String
            playlistIdList.append(persistentId)
            playlistNameList.append(playlistName!)
            
            // 1つのプレイリストに4つまでのアートワークを設定する
            var albumArtworkImageList: [MPMediaItemArtwork] = []
            var artworkCount = 0
            let songs = playlist.items
            for song in songs {
                if artworkCount < 4 {
                    if let artwork = song.artwork {
                        albumArtworkImageList.append(artwork)
                        artworkCount += 1
                    }
                }
            }
            albumArtworkAllImageDic[index] = albumArtworkImageList
            index += 1
        }
        
        self.tableView.allowsSelection = true
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return DataProvider.sharedInstance.postsData.count
        return playlistNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlaylistCell
        
        // プレイリスト名
        cell.mainLabel.text = playlistNameList[indexPath.row]
        
        // プレイリストに含まれるアートワーク数
        let artworkCount = Int((albumArtworkAllImageDic[indexPath.row]?.count)!)
        
        // アートワーク表示
        switch artworkCount {
        case 1:
            if let artworkImage1 = albumArtworkAllImageDic[indexPath.row]?[0] {
                cell.artworkImage1.image = artworkImage1.image(at: cell.artworkImage1.bounds.size)
            }
            cell.artworkImage2.image = UIImage(named: "album1")
            cell.artworkImage3.image = UIImage(named: "album1")
            cell.artworkImage4.image = UIImage(named: "album1")
            break
        case 2:
            if let artworkImage1 = albumArtworkAllImageDic[indexPath.row]?[0] {
                cell.artworkImage1.image = artworkImage1.image(at: cell.artworkImage1.bounds.size)
            }
            if let artworkImage2 = albumArtworkAllImageDic[indexPath.row]?[1] {
                cell.artworkImage2.image = artworkImage2.image(at: cell.artworkImage2.bounds.size)
            }
            cell.artworkImage3.image = UIImage(named: "album1")
            cell.artworkImage4.image = UIImage(named: "album1")
            break
        case 3:
            if let artworkImage1 = albumArtworkAllImageDic[indexPath.row]?[0] {
                cell.artworkImage1.image = artworkImage1.image(at: cell.artworkImage1.bounds.size)
            }
            if let artworkImage2 = albumArtworkAllImageDic[indexPath.row]?[1] {
                cell.artworkImage2.image = artworkImage2.image(at: cell.artworkImage2.bounds.size)
            }
            if let artworkImage3 = albumArtworkAllImageDic[indexPath.row]?[2] {
                cell.artworkImage3.image = artworkImage3.image(at: cell.artworkImage1.bounds.size)
            }
            cell.artworkImage4.image = UIImage(named: "album1")
            break
        case 4:
            if let artworkImage1 = albumArtworkAllImageDic[indexPath.row]?[0] {
                cell.artworkImage1.image = artworkImage1.image(at: cell.artworkImage1.bounds.size)
            }
            if let artworkImage2 = albumArtworkAllImageDic[indexPath.row]?[1] {
                cell.artworkImage2.image = artworkImage2.image(at: cell.artworkImage2.bounds.size)
            }
            if let artworkImage3 = albumArtworkAllImageDic[indexPath.row]?[2] {
                cell.artworkImage3.image = artworkImage3.image(at: cell.artworkImage1.bounds.size)
            }
            if let artworkImage4 = albumArtworkAllImageDic[indexPath.row]?[3] {
                cell.artworkImage4.image = artworkImage4.image(at: cell.artworkImage1.bounds.size)
            }
            break
        default:
            cell.artworkImage1.image = UIImage(named: "album1")
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistDetailVC = PlaylistDetailTableViewController()
        playlistDetailVC.playlistName = playlistNameList[indexPath.row]
//        let navigationController = UINavigationController(rootViewController: playlistDetailVC)
//        navigationController.heroNavigationAnimationType = .cover(direction: .left)
        self.navigationController?.pushViewController(playlistDetailVC, animated: true)
//        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension Array {
    func canAccess(index: Int) -> Bool {
        return self.count - 1 >= index
    }
}
