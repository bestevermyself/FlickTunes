//
//  PlaySinglesListViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/09/29.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import MediaPlayer
import DeckTransition

class PlaySinglesListViewControllerOld: UITableViewController {

    var singleTitleList: [String] = []
    var singleArtistList: [String] = []
    var singleJacketList: [UIImage] = []
    
    var songs: [MPMediaItem] = []
    var song: MPMediaItem = MPMediaItem()
    var songQuery: SongQuery = SongQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        modalPresentationCapturesStatusBarAppearance = true
        
        // nibNameへはステップ２や３で作成したXibファイルの名前を拡張子抜きで指定。
        // forCellReuseIdentifierへはステップ４で設定したReuseIdentifierを指定。
        tableView.register(UINib(nibName: "SongListTableViewCell", bundle: nil), forCellReuseIdentifier: "songCell")
        
        self.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // 1. 生成するセルをカスタムクラスへダウンキャスト
            // 既存のCell生成コードの後に as! <Cellのカスタムクラス名> という記述を追加
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongListTableViewCell
            
            // 2. CustomCellの初期化コードを記述
            cell.songName.text = songs[indexPath.row].title
            cell.songArtistName.text = songs[indexPath.row].artist
            //        cell.songJacketImage.image = songs[indexPath.row]
            
            //        cell.songName.text = album.songs[indexPath.row]
            //        cell.songArtistName.text = album.songs[indexPath.row]
            //        cell.songJacketImage.image = singleJacketList[indexPath.row]
            
            return cell
        }
    
    // セルの高さを指定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セルがタップされたときのイベント
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO 再生画面へ
        //        let playMusicVC = PlayMusicViewController()
        
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        //        song = songQuery.getItem(songId: songs[indexPath.row].persistentID as! NSNumber)
        //        playMusicVC.song = song
        //        print(song.title!)
        
        playMusicVC.queryItems = songs
        playMusicVC.selectedIndex = indexPath.row
        // present(playMusicVC, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isEqual(tableView) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            
            // スクロールビューのコンテンツサイズを設定
            //            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 7200)
            //            scrollView.translatesAutoresizingMaskIntoConstraints = true
            //            reloadTableView(self.tableView)
            
            if scrollView.contentOffset.y > 0 {
                
                scrollView.bounces = true
//                delegate.isDismissEnabled = false
                
            } else {
                
                if scrollView.isDecelerating {
                    
                    view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                    scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
                    
                } else {
                    
                    scrollView.bounces = false
//                    delegate.isDismissEnabled = true
                    
                }
            }
        }
    }
    
    func reloadTableView(_ tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }

        
}

