//
//  SongListTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/05/21.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import MediaPlayer
import DeckTransition

class SongListTableViewController: UITableViewController {
    
    var mediaQuery: MPMediaQuery = MPMediaQuery.songs()
    
    var singleTitleList: [String] = []
    var singleArtistList: [String] = []
    var singleJacketList: [UIImage] = []
    
    var songs: [SongInfo] = []
    var songQuery: SongQuery = SongQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // tableViewの編集モード有効
        self.tableView.isEditing = true
        
        // 編集モード時でもタップ可能にする
        self.tableView.allowsSelectionDuringEditing = true
        
        modalPresentationCapturesStatusBarAppearance = true
        
        // nibNameへはステップ２や３で作成したXibファイルの名前を拡張子抜きで指定。
        // forCellReuseIdentifierへはステップ４で設定したReuseIdentifierを指定。
        tableView.register(UINib(nibName: "SongListTableViewCell", bundle: nil), forCellReuseIdentifier: "songCell")
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        mediaQuery = ImageGalleryViewController().mediaQuery
        
        createSongPlaylist()
        
        self.tableView.reloadData()
        
    }
    
    // 与えられたrowが編集可能かどうか指定
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // すべてのセルで編集可能とするためtrue
        return true
    }
    
    // row の変更があった場合に呼ばれるメソッド
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // セルがドロップされたときの処理
        print("drop Event")
    }
    
    // row が移動可能かどうかを指定
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // すべて移動可能にするためtrue
        return true
    }
    
    // 編集のスタイルを指定
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    // 編集モード時にインデントを付けるか
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return singleTitleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. 生成するセルをカスタムクラスへダウンキャスト
        // 既存のCell生成コードの後に as! <Cellのカスタムクラス名> という記述を追加
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongListTableViewCell
        
        // 2. CustomCellの初期化コードを記述
        cell.songName.text = singleTitleList[indexPath.row]
        cell.songArtistName.text = singleArtistList[indexPath.row]
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
        print(indexPath.row)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createSongPlaylist() {
        
        let collections = mediaQuery.collections
        
        var songCnt = 0
        for_album: for album in collections! {
            let title = album.representativeItem?.albumTitle ?? ""  // アルバム名
            let artist = album.representativeItem?.albumArtist ?? ""  // アーティスト名
         
            for single in (album.items) {
    //            let id = single.valueForProperty(MPMediaItemPropertyPersistentID).stringValue  // 一意の id
                let title = single.value(forProperty: MPMediaItemPropertyTitle) as? String  // シングル名
                singleTitleList.append(title!)
                
                let artist = single.value(forKey: MPMediaItemPropertyArtist) as? String  // アーティスト名
                singleArtistList.append(artist!)
                
                let artwork = single.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork  // ジャケット
                if let artwork = artwork, let artworkImage = artwork.image(at: artwork.bounds.size) {
                    // artworkImage に UIImage として保持されている
                    singleJacketList.append(artworkImage)
                }
                songCnt += 1
                
                // 100曲まで表示対応
                if (songCnt > 100) {
                    break for_album
                }
            }
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isEqual(tableView) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            
            // スクロールビューのコンテンツサイズを設定
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 7200)
            scrollView.translatesAutoresizingMaskIntoConstraints = true
            reloadTableView(self.tableView)
        
            if scrollView.contentOffset.y > 0 {
                scrollView.bounces = true
//                delegate.isSwipeToDismissEnabled = false
			} else {
				if scrollView.isDecelerating {
					view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
					scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
				} else {
					scrollView.bounces = false
//                    delegate.isSwipeToDismissEnabled = true
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
