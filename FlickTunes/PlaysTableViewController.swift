//
//  PlaysTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/15.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import XLPagerTabStrip

class PlaysTableViewController: UITableViewController, IndicatorInfoProvider {

//    var sectionName: [String] = ["10", "20", "30", "40", "50", "60", "70", "80", "90"]
    var sectionTitles: [String] = []
//    var playsList: [Int: [MPMediaItem]] = [:]
    var playsList: [Int: MPMediaItem] = [:]
    var artistName: String = ""
    var mediaItems: [MPMediaItem] = []
    let cellIdentifier = "PlaysCell"
    var shuffleMusicList: [MPMediaEntityPersistentID] = []
    
    var songQuery: SongQuery = SongQuery()
    let query = MPMediaQuery.songs()
    
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
        
        for i in 1...100 {
            sectionTitles.append(String(i))
        }
        
        // XLPagerTabStripとセルの間に出来る謎のマージンを解消
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        
        
        // 再生回数トップ100を抽出
        if var allArray = query.items! as? [MPMediaItem] {
            
            // 再生回数と曲名でソート
            allArray.sort() { s0, s1 in
                if s0.playCount == s1.playCount {
                    // FIXME
                    return s0.title! < s1.title!
                } else {
                    return s1.playCount < s0.playCount
                }
            }
            
            // 最大で100件抽出
            mediaItems = [MPMediaItem](allArray[0..<100])
        }
        
        // 10件ずつセクション分け
        /*
        var songs: [MPMediaItem] = []
        for (index, song) in mediaItems.enumerated() {
            songs.append(song)
            if (songs.count == 10) {
                let sectionIndex = Int((index + 1) / 10 - 1)
                playsList[sectionIndex] = songs
                songs = []
            }
        }
        */
        // 1件ずつセクション分け
        for (index, song) in mediaItems.enumerated() {
            print(index)
            playsList[index] = song
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // ボタン作成
        // barButtonSystemItemを変更すればいろいろなアイコンに変更できます
        var backButton: UIBarButtonItem = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(PlaysTableViewController.actionBackButton))
        var searchButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(PlaysTableViewController.actionSearchButton))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setLeftBarButtonItems([backButton], animated: true)
        self.navigationItem.setRightBarButtonItems([searchButton], animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
//    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return index
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // 索引表示名
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlaysCell
//        let mediaItems = playsList[indexPath.section]
//        let mediaItem = mediaItems?[indexPath.row]
        
        let mediaItem = playsList[indexPath.section]
        // シャッフルリストを作成
//        shuffleMusicList.append((mediaItem?.persistentID)!)
        
        // 再生順位
        cell.rank.text = String(describing: indexPath[0] + 1)
        // 曲名
        cell.artistName.text = mediaItem?.title
        
        // 再生回数
        let playCount = mediaItem?.playCount
        cell.playCount.text = playCount?.description
        
        // アートワーク表示
        if let artwork = mediaItem?.artwork {
            let image = artwork.image
            // アートワークを丸抜きイメージにする
//            cell.artistImage.layer.cornerRadius = cell.artistImage.frame.width / 2
//            cell.artistImage.clipsToBounds = true
            cell.artistImage.image = image(cell.artistImage.bounds.size)
        } else {
            // アートワークがないとき(灰色表示)
            cell.artistImage.image = UIImage(named: "album1")
        }

        return cell
    }

    // セルを選択したときの処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        
        print("section is " + String(indexPath.section))
        print("indexPath is " + String(describing: indexPath))
        
        playMusicVC.queryItems = mediaItems
        playMusicVC.selectedIndex = Int(indexPath.section)
        present(playMusicVC, animated: true, completion: nil)
        
//        let musicId = mediaItems[indexPath.row].persistentID
//        let playMusicVC = PlayMusicViewController()
//        playMusicVC.song = mediaItems[indexPath.row] as! MPMediaItem
//        playMusicVC.musicId = musicId
//        playMusicVC.query = query
//        playMusicVC.sing= [MPMediaItemCollection(items: mediaItems)]
    }
    
    @objc func actionSearchButton(){
        //searchButtonを押した際の処理を記述
        for (index, music) in shuffleMusicList.enumerated() {
            print(shuffleMusicList[index])
        }
    }
    
    @objc func actionBackButton(){
        //refreshButtonを押した際の処理を記述
        dismiss(animated: true, completion: nil)
    }

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
