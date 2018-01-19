//
//  ArtistItemsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/20.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class ArtistItemsTableViewController: UITableViewController {


//    var itemCollection = MPMediaItemCollection()
    
    var sectionNameList: [String] = []
    var albumTitleList: [String] = []
    var albumPersistentIdList: [MPMediaEntityPersistentID] = []
    var albumArtworkImageList: [MPMediaItemArtwork] = []
    
    var artistName: String = ""
    var mediaItems: [MPMediaItem] = []
    let cellIdentifier = "ArtistCell"
    var shuffleMusicList: [MPMediaEntityPersistentID] = []
    
    var songQuery: SongQuery = SongQuery()

    /*
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        
        let property = MPMediaPropertyPredicate(value: artistName, forProperty: MPMediaItemPropertyArtist)
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(property)
        mediaItems = query.items!
        for mediaCollection in query.collections! {
            albumTitleList.append(mediaCollection.representativeItem?.albumTitle ?? (mediaCollection.representativeItem?.title)!)
            albumPersistentIdList.append((mediaCollection.representativeItem?.albumPersistentID)!)
            sectionNameList.append((mediaCollection.representativeItem?.albumTitle)!)
            if let artworkImage = mediaCollection.representativeItem?.artwork {
                albumArtworkImageList.append((mediaCollection.representativeItem?.artwork)!)
            } else {
                albumArtworkImageList.append(MPMediaItemArtwork(image: UIImage(named: "album1")!))
            }
        }

//        for item in mediaItems {
//            let titleName = item.albumTitle ?? item.title
//            sectionList.append(titleName!)
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // ボタン作成
        // barButtonSystemItemを変更すればいろいろなアイコンに変更できます
        var backButton: UIBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(ArtistItemsTableViewController.actionBackButton))
        var searchButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ArtistItemsTableViewController.actionSearchButton))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setLeftBarButtonItems([backButton], animated: true)
        self.navigationItem.setRightBarButtonItems([searchButton], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = artistName
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionNameList.count
    }
    
    /*
     セクションの数を返す.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNameList.count
    }

    /*
     セクションのタイトルを返す.
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNameList[section] as? String
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
//        let mediaItem = mediaItems[indexPath.row]
        
        // シャッフルリストを作成
//        shuffleMusicList.append(mediaItem.persistentID)
        
        // アルバム名
//        cell.artistName.text = mediaItem.title
        cell.artistName.text = sectionNameList[indexPath.row]
        
        // アートワーク表示
        let artwork = albumArtworkImageList[indexPath.row]
        if let artworkImage = artwork.image(at: cell.artistImage.bounds.size) {
            // アートワークを丸抜きイメージにする
//            cell.artistImage.layer.cornerRadius = cell.artistImage.frame.width / 2
//            cell.artistImage.clipsToBounds = true
            cell.artistImage.image = artworkImage
        } else {
            // アートワークがないとき(灰色表示)
            cell.artistImage.image = UIImage(named: "album1")
        }
//        let artwork = single.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork  // ジャケット
//        cell.artistImage.image = item.value(forProperty: MPMediaItemArtwork) as? MPMediaItemArtwork

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
//        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
//        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        
//        let musicId = mediaItems[indexPath.row].persistentID
//        let playMusicVC = PlayMusicViewController()
//        playMusicVC.song = mediaItems[indexPath.row] as! MPMediaItem
//        playMusicVC.musicId = musicId
        
        let artistDetailVC = ArtistDetailTableViewController()
        artistDetailVC.albumTitle = albumTitleList[indexPath.row]
        artistDetailVC.albumPersistentId = albumPersistentIdList[indexPath.row]
        self.navigationController?.pushViewController(artistDetailVC, animated: true)
//        navigationController?.present(artistDetailVC, animated: true, completion: nil)
    }
    
    @objc func actionSearchButton(){
        //searchButtonを押した際の処理を記述
        for (index, music) in shuffleMusicList.enumerated() {
            print(shuffleMusicList[index])
        }
    }
    
    @objc func actionBackButton(){
        //refreshButtonを押した際の処理を記述
        
        //前画面に戻る。
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }

}
