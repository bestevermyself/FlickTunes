//
//  PlaylistDetailTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/14.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

// import Hero
import UIKit
import MediaPlayer

class PlaylistDetailTableViewController: UITableViewController {

    var query = MPMediaQuery()
    
    var sectionList: [String] = []
    var playlistName: String = ""
    var mediaItems: [MPMediaItem] = []
    let cellIdentifier = "ArtistCell"
    var shuffleMusicList: [MPMediaEntityPersistentID] = []
    
    var songQuery: SongQuery = SongQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.heroID = "playlistDetailTable"
        
        tableView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        
        let property = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName)
        query.addFilterPredicate(property)
        
        mediaItems = query.items!
        
        var mediaCollections = query.collections!
        for mediaCollection in mediaCollections {
            sectionList.append((mediaCollection.representativeItem?.albumTitle)!)
        }
        let orderedSet = NSOrderedSet(array: sectionList)
        sectionList = orderedSet.array as! [String]

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
        var backButton: UIBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(PlaylistDetailTableViewController.actionBackButton))
        var searchButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(PlaylistDetailTableViewController.actionSearchButton))
        
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setLeftBarButtonItems([backButton], animated: true)
        self.navigationItem.setRightBarButtonItems([searchButton], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = playlistName
        
        self.navigationBarAndStatusBarHidden(hidden: false, animated: true)
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
        return sectionList.count
    }

    /*
     セクションのタイトルを返す.
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section] as? String
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
            // アートワークを丸抜きイメージにする
//            cell.artistImage.layer.cornerRadius = cell.artistImage.frame.width / 2
//            cell.artistImage.clipsToBounds = true
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

    /*
     セルを選択したとき
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        playMusicVC.modalPresentationStyle = .fullScreen
        playMusicVC.modalTransitionStyle = .coverVertical
        
//        let musicId = mediaItems[indexPath.row].persistentID
//        let playMusicVC = PlayMusicViewController()
//        playMusicVC.song = mediaItems[indexPath.row] as! MPMediaItem
        playMusicVC.playlistsName = playlistName
//        playMusicVC.musicId = musicId
        
//        let property = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName)
//        query.addFilterPredicate(property)
//        mediaItems = query.items!
//        print("再生中のプレイリスト" + playlistName + "インデックスパス：" + String(indexPath.row))
        
        playMusicVC.selectedIndex = indexPath.row
        playMusicVC.queryItems = mediaItems
//        playMusicVC.query = query
        
        present(playMusicVC, animated: true, completion: nil)
        
//        playMusicVC.heroModalAnimationType = .push(direction: .left)
//        hero_replaceViewController(with: playMusicVC)
    }
    
    @objc func actionSearchButton(){
        //searchButtonを押した際の処理を記述
        for (index, music) in shuffleMusicList.enumerated() {
            print(shuffleMusicList[index])
        }
    }
    
    @objc func actionBackButton(){
        //refreshButtonを押した際の処理を記述
        self.navigationController?.popToRootViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    func navigationBarAndStatusBarHidden(hidden: Bool, animated: Bool) {
        if let nv = navigationController {
            
            if nv.isNavigationBarHidden == hidden {
                return
            }
            
            let application = UIApplication.shared
            
            if (hidden) {
                // 隠す
                nv.setNavigationBarHidden(hidden, animated: animated)
                application.setStatusBarHidden(hidden, with: animated ? .slide : .none)
            } else {
                // 表示する
                application.setStatusBarHidden(hidden, with: animated ? .slide : .none)
                nv.setNavigationBarHidden(hidden, animated: animated)
            }
        }
    }

    

}
