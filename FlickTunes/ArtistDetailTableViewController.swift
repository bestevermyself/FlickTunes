//
//  ArtistDetailTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/12.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import MediaPlayer

class ArtistDetailTableViewController: UITableViewController {

    var query = MPMediaQuery.albums()
    
    var sectionNameList: [String] = []
    var albumPersistentId: MPMediaEntityPersistentID = UInt64()
    var albumTitle: String = ""
    var artistName: String = ""
    var mediaItems: [MPMediaItem] = []
    let cellIdentifier = "ArtistCell"
    var shuffleMusicList: [MPMediaEntityPersistentID] = []
    
    var songQuery: SongQuery = SongQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        
        let property = MPMediaPropertyPredicate(value: albumPersistentId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        query.addFilterPredicate(property)
        mediaItems = query.items!
        
        // ボタン作成
        // barButtonSystemItemを変更すればいろいろなアイコンに変更できます
        var backButton: UIBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(ArtistDetailTableViewController.actionBackButton))
        var searchButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ArtistDetailTableViewController.actionSearchButton))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setLeftBarButtonItems([backButton], animated: true)
        self.navigationItem.setRightBarButtonItems([searchButton], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = albumTitle
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mediaItems.count
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
        let mediaItem = mediaItems[indexPath.row]
        
        // シャッフルリストを作成
        shuffleMusicList.append(mediaItem.persistentID)
        
        // 曲名
        cell.artistName.text = mediaItem.title
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image
            cell.artistImage.image = image(cell.artistImage.bounds.size)
        } else {
            // アートワークがないとき(灰色表示)
//            musicArtWork.image = nil
//            musicArtWork.backgroundColor = UIColor.gray
        }
//        let artwork = single.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork  // ジャケット
//        cell.artistImage.image = item.value(forProperty: MPMediaItemArtwork) as? MPMediaItemArtwork

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        
//        let musicId = mediaItems[indexPath.row].persistentID
//        let playMusicVC = PlayMusicViewController()
//        playMusicVC.song = mediaItems[indexPath.row] as! MPMediaItem
        playMusicVC.selectedIndex = indexPath.row
        playMusicVC.queryItems = mediaItems
        playMusicVC.query = query
        
//        playMusicVC.musicId = musicId
        navigationController?.present(playMusicVC, animated: true, completion: nil)
    }
    
    @objc func actionSearchButton(){
        //searchButtonを押した際の処理を記述
        for (index, music) in shuffleMusicList.enumerated() {
            print(shuffleMusicList[index])
        }
    }
    
    @objc func actionBackButton(){
        //refreshButtonを押した際の処理を記述
//        dismiss(animated: true, completion: nil)
        
        //前画面に戻る。
        self.navigationController?.popViewController(animated: true)
    }

}
