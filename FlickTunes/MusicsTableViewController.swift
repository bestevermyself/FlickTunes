//
//  MusicsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/16.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import XLPagerTabStrip

class MusicsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var collections: [MPMediaItemCollection] = MPMediaQuery.songs().collections!
    var collectionSections: [MPMediaQuerySection] = MPMediaQuery.songs().collectionSections!
    var collectionSectionTitles: [String] = []
    var query = MPMediaQuery.songs()
    
    var songs = [SongInfo]()
    var artistNameList: [String] = []
    var songNameList: [String] = []
    
    let cellIdentifier = "PostCell"
    var blackTheme = false
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
        
        
        self.collections = query.collections!
        self.collectionSections = query.collectionSections!
        
        for section in self.collectionSections {
            self.collectionSectionTitles.append(section.title)
        }
        
        
        // XLPagerTabStripとセルの間に出来る謎のマージンを解消
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        
    
        /*
        let songsQuery = MPMediaQuery.songs()
        let songItem = songsQuery.collections as! [MPMediaItemCollection]
        for item in songItem {
//            let artist = item.representativeItem?.artist ?? ""  // アーティスト名
            let artist = item.representativeItem?.artist ?? "" // 曲名
            let song = item.representativeItem?.title ?? "" // 曲名
            let artwork = item.representativeItem?.artwork ?? MPMediaItemArtwork(image: UIImage(named: "album1")!)
            artistNameList.append(artist)
            songNameList.append(song)
            
            songs.append(SongInfo(
                title: song
                , album: ""
                , artist: artist
//                , artwork: item.representativeItem?.artwork ?? UIImage(named: "album1") as! MPMediaItemArtwork
                , artwork: artwork
                , persistentID: item.representativeItem?.persistentID as! NSNumber
            ))
        }
        */
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        return self.collectionSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.collectionSections[section]
        return section.title
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.collectionSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return DataProvider.sharedInstance.postsData.count
//        return artistNameList.count
        let section = self.collectionSections[section]
        return section.range.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostCell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArtistCell,
//            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
//        cell.configureWithData(data)
//        if blackTheme {
//            cell.changeStylToBlack()
//        }
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
        let song = rowItem.representativeItem
        
        cell.postName.text = song?.value(forKey: MPMediaItemPropertyTitle) as! String
        cell.postText.text = song?.value(forKey: MPMediaItemPropertyArtist) as! String
        
        let artwork = song?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        // artworkImage に UIImage として保持されている
        if let artwork = artwork, let artworkImage = artwork.image(at: artwork.bounds.size) {
            cell.userImage.image = artworkImage
        }
        
        /*
        cell.postName.text = songNameList[indexPath.row]
        cell.postText.text = artistNameList[indexPath.row]        
        
        // アートワーク表示
        let image = songs[indexPath.row].artwork
//        if let artwork = songs[indexPath.row].artwork {
//            let image = artwork.image
            // アートワークを丸抜きイメージにする
//            cell.userImage.layer.cornerRadius = cell.userImage.frame.width / 2
//            cell.userImage.clipsToBounds = true
            cell.userImage.image = image.image(at: cell.userImage.bounds.size)
        
//        }
        */
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
//        ctrl.itemCollection = mic;
        
        
        
        // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        playMusicVC.singles = rowItem.items
        playMusicVC.query = query
        playMusicVC.selectedIndex = section.range.location + indexPath.row
        
//        let musicId = songs[indexPath.row].persistentID
//        let musicId = rowItem.representativeItem?.persistentID
//        playMusicVC.song = mediaItems[indexPath.row] as! MPMediaItem
//        playMusicVC.musicId = MPMediaEntityPersistentID(musicId!)
        present(playMusicVC, animated: true, completion: nil)
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
