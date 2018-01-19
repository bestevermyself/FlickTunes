//
//  PlaySinglesListViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2018/01/14.
//  Copyright © 2018年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import MediaPlayer
import PopupDialog

final class PlaySinglesListViewController: UIViewController {

    // MARK: Public
    
    /// The PopupDialog this view is contained in
    /// Note: this has to be weak, otherwise we end up
    /// creating a retain cycle!
    public weak var popup: PopupDialog?
    
    var singleTitleList: [String] = []
    var singleArtistList: [String] = []
    var singleJacketList: [UIImage] = []
    
    var songs: [MPMediaItem] = []
    var song: MPMediaItem = MPMediaItem()
    var songQuery: SongQuery = SongQuery()
    
    /// The city the user did choose
//    public fileprivate(set) var selectedCity: String?
    
    /// A list of cities to display
//    public var cities = [String]() {
//        didSet { baseView.tableView.reloadData() }
//    }
    
    // MARK: Private
    
    // We will use this instead to reference our
    // controllers view instead of `view`
    fileprivate var baseView: PopupTableView {
        return view as! PopupTableView
    }
    
    // MARK: View related
    
    // Replace the original controller view
    // with our dedicated view
    override func loadView() {
        view = PopupTableView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the dialog (custom) title
        baseView.titleLabel.text = "Single List"
        
        // Setup tableView
//        baseView.tableView.register(SongListTableViewCell.self, forCellReuseIdentifier: songCell.cellIdentifier)
        baseView.tableView.register(UINib(nibName: "PlaySinglesListCell", bundle: nil), forCellReuseIdentifier: "playSinglesListCell")
        baseView.tableView.dataSource = self as! UITableViewDataSource
        baseView.tableView.delegate = self as! UITableViewDelegate
    }
}

// MARK: - TableView Data Source

extension PlaySinglesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: PopupTableViewCell.cellIdentifier, for: indexPath)
//        cell.textLabel?.text = cities[indexPath.row]
        // 1. 生成するセルをカスタムクラスへダウンキャスト
        // 既存のCell生成コードの後に as! <Cellのカスタムクラス名> という記述を追加
        let cell = tableView.dequeueReusableCell(withIdentifier: "playSinglesListCell", for: indexPath) as! PlaySinglesListCell
        
        // 2. CustomCellの初期化コードを記述
        cell.songName.text = songs[indexPath.row].title
        cell.songNumber.text = String(describing: indexPath.row + 1)
//        cell.songArtistName.text = songs[indexPath.row].artist
        //        cell.songJacketImage.image = songs[indexPath.row]
        
        //        cell.songName.text = album.songs[indexPath.row]
        //        cell.songArtistName.text = album.songs[indexPath.row]
        //        cell.songJacketImage.image = singleJacketList[indexPath.row]
        
        return cell
    }
}

// MARK: - TableView Delegate

extension PlaySinglesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCity = cities[indexPath.row]
        // TODO 再生画面へ
        //        let playMusicVC = PlayMusicViewController()
        
        let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
        let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
        //        song = songQuery.getItem(songId: songs[indexPath.row].persistentID as! NSNumber)
        //        playMusicVC.song = song
        //        print(song.title!)
        
        playMusicVC.queryItems = songs
        playMusicVC.selectedIndex = indexPath.row
        
        playMusicVC.player.stop()
        let collection = MPMediaItemCollection(items: songs) //it needs the "!"
        playMusicVC.player.setQueue(with: collection)
        playMusicVC.player.nowPlayingItem = collection.items[indexPath.row]
        playMusicVC.player.play()
        // present(playMusicVC, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
//        playMusicVC.updateSongInformationUI(mediaItem: collection.items[indexPath.row])
        
        popup?.dismiss(animated: true)
    }
}

