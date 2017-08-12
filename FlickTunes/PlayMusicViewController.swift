//
//  PlayMusicViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/05/02.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import MediaPlayer
import Pastel
import ShadowImageView
import DeckTransition

class PlayMusicViewController: UIViewController {
    
    @IBOutlet var musicArtWorkShadow: ShadowImageView!
    @IBOutlet var musicArtWork: UIImageView!
    @IBOutlet var musicTitle: UILabel!
    @IBOutlet var musicArtist: UILabel!
    
    @IBOutlet var musicPlayButton: UIButton!
    @IBOutlet var musicRepeatButton: UIButton!
    @IBOutlet var musicShuffleButton: UIButton!
    
    @IBOutlet var volumeSlider: UISlider!
    private var systemVolumeSlider: UISlider!
    
    var selectedIndex: IndexPath?
    var musicId: MPMediaEntityPersistentID = MPMediaEntityPersistentID()
    var isPlaying: Bool?
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
//    var song: MPMediaItem = MPMediaItem()
    var song: MPMediaItem = MPMediaItem()
    
    var player = MPMusicPlayerController()
    var playlistsName: [String] = []
    var playlistsIndex: Int = 0
    var playMusicTitle: String = ""
    
    let notificationCenter = NotificationCenter.default
//    let songsMediaQuery = MPMediaQuery.songs()
//    var playlistsMediaQuery = MPMediaQuery.playlists()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let property = MPMediaPropertyPredicate(value: musicId, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(property)
        var single = query.items!
        song = single[0] 
        
        // 音量調整のため、システム音量設定画面をaddview
        self.view.backgroundColor = UIColor.clear
        let mpVolumeView = MPVolumeView(frame: self.view.bounds)
        mpVolumeView.isHidden = true;
        self.view.addSubview(mpVolumeView)
        
        // 音量調整用のスライダーを取得
        for childView in mpVolumeView.subviews {
            // MPVolumeSliderクラスで探索
            if (NSStringFromClass(type(of: (childView as NSObject))).isEqual("MPVolumeSlider")) {
                self.systemVolumeSlider = childView as! UISlider
            }
        }
        let audioSession = AVAudioSession.sharedInstance()
//        let volume = audioSession.outputVolume
//        volumeSlider.value = self.systemVolumeSlider.value
//        volumeSlider.value = volume
        
        // デバイス横ボリュームボタン押下時にpostされるNotificationの、observer登録
//        notificationCenter.addObserver(self, selector: #selector(deviceVolumeChanged(_:)), name: .AVSystemController_SystemVolumeDidChangeNotification, object: nil)
        
        
        // UserDefaultsから選択された曲のインデックス値を取得
//        print("受け取ったインデックス値\(selectedMusic!)")
        
//        player.pause()
        player.nowPlayingItem = song
//        player.play()
        
        // 受け取ったIDから楽曲検索
        /*
        let property = MPMediaPropertyPredicate(value: musicId, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(property)
        let collection = MPMediaItemCollection(items: query.items!)
        player.setQueue(with: collection)
        player.play()
        
        let predicate = MPMediaPropertyPredicate(value: musicId, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery(filterPredicates: [predicate])
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: query)
        player.nowPlayingItem = descriptor.itemCollection.items.first
//          MPMusicPlayerController.systemMusicPlayer().append(descriptor)
        // MPMusicPlayerController.systemMusicPlayer().prepend(descriptor)
//         player.skipToNextItem()
        */
    
        notificationCenter.addObserver(self, selector: #selector(PlayMusicViewController.nowPlayingItemChanged(_:))
            , name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
        
        // 端末にないアイテムを取り除く
        /*
        songsMediaQuery.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
        let predicateFilter = MPMediaPropertyPredicate(value: playMusicTitle, forProperty: MPMediaItemPropertyTitle)
        songsMediaQuery.filterPredicates = NSSet(object: predicateFilter) as? Set<MPMediaPredicate>
        player.setQueue(with: songsMediaQuery)
        player.play()
        */
        
        /**
         - タップイベント処理
        */
        
        // double tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        
        // single tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        
        // ダブルタップ時にシングルタップのアクションが実行されないようにする
        singleTap.require(toFail: doubleTap)
        
        self.view.addGestureRecognizer(doubleTap)
        self.view.addGestureRecognizer(singleTap)
        
        /**
         - スワイプイベント処理
        */
        // single swipe up
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUpGesture.numberOfTouchesRequired = 1
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.up
        
        // single swipe down
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGesture.numberOfTouchesRequired = 1
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
        
        // single swipe left
        let swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftGesture.numberOfTouchesRequired = 1
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        
        // single swipe right
        let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.numberOfTouchesRequired = 1
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeUpGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
        self.view.addGestureRecognizer(swipeLeftGesture)
        self.view.addGestureRecognizer(swipeRightGesture)
        
        // バックグラウンドグラデーションを有効
        addPastelBackground()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 再生中ボタンからか？
//        let vc = ImageGalleryViewController()
//        vc.isNowPlayButton = false
        
        // 再生中か？
        isPlaying = isPlayerPlaying()
    
//        player.pause()
//        player.nowPlayingItem = song
//        playerPlayEvent()
            
        notificationCenter.addObserver(self,
                                       selector: #selector(systemVolumeDidChange),
                                       name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                       object: nil
        )
        
    }
    
    /**
     - 背景にエフェクトを追加
    */
    func addPastelBackground() {
        
        let pastelView = PastelView(frame: self.view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        // Custom Direction
        
        pastelView.startAnimation()
        self.view.insertSubview(pastelView, at: 0)
        
    }

    func setSystemVolume(volume: Float) {
        let volumeView = MPVolumeView()
        
        for view in volumeView.subviews {
            if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
                let slider = view as! UISlider
                slider.setValue(volume, animated: false)
            }
        }
    }
    
    @IBAction func volumeSliderEvent(_ sender: Any) {
        print(volumeSlider.value)
        setSystemVolume(volume: volumeSlider.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func musicForward(_ sender: Any) {
        
        player.skipToPreviousItem()
        
    }
    
    
    @IBAction func musicNext(_ sender: Any) {
        
        player.skipToNextItem()
        
    }
    
    @IBAction func musicRepeat(_ sender: Any) {
        
        repeatStateCheck()
        
    }
    
    @IBAction func musicShuffle(_ sender: Any) {
        
        shuffleStateCheck()
        
    }
    
    /**
     - リピート状態をチェックする
    */
    func repeatStateCheck() {
        
        let repeatMode = player.repeatMode
        if repeatMode == .default {
            player.repeatMode = .none
        }
        
        switch player.repeatMode {
            
            case .none:
                player.repeatMode = .all
                self.musicRepeatButton.setImage(UIImage(named: "repeatAll"), for: .normal)
                self.musicRepeatButton.tintColor = UIColor.red
            case .all:
                player.repeatMode = .one
                self.musicRepeatButton.setImage(UIImage(named: "repeatOne"), for: .normal)
                self.musicRepeatButton.tintColor = UIColor.red
            case .one:
                player.repeatMode = .none
                self.musicRepeatButton.setImage(UIImage(named: "repeatAll"), for: .normal)
                self.musicRepeatButton.tintColor = UIColor.lightGray
            default:
                player.repeatMode = .default
                self.musicRepeatButton.setImage(UIImage(named: "repeatAll"), for: .normal)
                self.musicRepeatButton.tintColor = UIColor.lightGray
            
        }
        
    }
    
    /**
     - シャッフル状態をチェックする
    */
    func shuffleStateCheck() {
        
        let shuffleMode = player.shuffleMode
        if shuffleMode == .default {
            player.shuffleMode = .off
        }
        
        // TODO アイコン変更
        switch player.shuffleMode {
            
            case .off:
                player.shuffleMode = .songs
                self.musicShuffleButton.tintColor = UIColor.blue
            case .songs:
                player.shuffleMode = .albums
                self.musicShuffleButton.tintColor = UIColor.red
            case .albums:
                player.shuffleMode = .off
                self.musicShuffleButton.tintColor = UIColor.lightGray
            default:
                player.shuffleMode = .default
                self.musicShuffleButton.tintColor = UIColor.lightGray
            
        }
        
    }
    
    
    func nowPlayingItemChanged(_ notification: NSNotification) {
        
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        
    }
    
    /**
     - 曲情報を表示する
    */
    func updateSongInformationUI(mediaItem: MPMediaItem) {
        
        // 曲情報表示
        // (a ?? b は、a != nil ? a! : b を示す演算子です)
        // (aがnilの場合にはbとなります)
        musicArtist.adjustsFontSizeToFitWidth = true
        musicArtist.sizeToFit()
        musicArtist.minimumScaleFactor = 0.6
        musicArtist.textAlignment = .center
        musicArtist.textColor = .white
        musicArtist.text = mediaItem.artist ?? "不明なアーティスト"
//        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        musicTitle.adjustsFontSizeToFitWidth = true
        musicTitle.sizeToFit()
        musicTitle.minimumScaleFactor = 0.6
        musicTitle.textAlignment = .center
        musicTitle.textColor = .white
        musicTitle.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: musicArtWork.bounds.size)
            musicArtWorkShadow.image = image
//            musicArtWork.image = image
        } else {
            // アートワークがないとき(灰色表示)
            musicArtWork.image = nil
            musicArtWork.backgroundColor = UIColor.gray
        }
        
    }
    
    deinit {
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }
    
    /**
     - タップイベント
    */
    func singleTap(sender: UITapGestureRecognizer) {
        print("single Tap!")
    }
    
    func doubleTap(sender: UITapGestureRecognizer) {
        print("double Tap!")
        // SongListTableView
        /*
        let songListTableVC = SongListTableViewController()
        songListTableVC.modalPresentationStyle = .overCurrentContext
        songListTableVC.view.backgroundColor = UIColor.clear
        present(songListTableVC, animated: true, completion: nil)
        */
        
        // DeckTransitionモーダルView
        /*
        let modal = SongListTableViewController()
        let transitionDelegate = DeckTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
 */
        
    }
    
    
    /**
     - スワイプイベント
    */
    internal func swipeGesture(sender: UISwipeGestureRecognizer){
        let touches = sender.numberOfTouches
        print("\(touches)")
    }
    
    func handleSwipeUp(sender: UITapGestureRecognizer) {
        
        playerPlayEvent()
        print("Swiped Up!!!")
        
    }
    
    func handleSwipeDown(sender: UITapGestureRecognizer) {
        
        playerStopEvent()
        print("Swiped Down!!!")
        
    }
    
    func handleSwipeLeft(sender: UITapGestureRecognizer) {
        
        player.skipToPreviousItem()
        print("Swiped Left!!!")
        
        /*
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: {
            self.musicArtWork.frame.origin.x -= 50.0
        }, completion: nil)
        
        self.view.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 1.0) {
                self.view.alpha = 1.0
            }
        }
        
        var startLocation = CGPoint(x: 0, y: 0)
        if (sender.state == UIGestureRecognizerState.began) {
            startLocation = sender.location(in: self.view);
        }
        else if (sender.state == UIGestureRecognizerState.ended) {
            let stopLocation = sender.location(in: self.view);
            let dx = stopLocation.x - startLocation.x;
            let dy = stopLocation.y - startLocation.y;
            let distance = sqrt(dx*dx + dy*dy );
            NSLog("Distance: %f", distance);
            
            if distance > 400 {
                musicArtWork.alpha = distance - 400
            }
         
        }
        */

        
    }
    
    func handleSwipeRight(sender: UITapGestureRecognizer) {
        
        player.skipToNextItem()
        print("Swiped Right!!!")
        
    }
    
    @IBAction func musicPlayButton(_ sender: Any) {
        
        /*
         - playbackStateは信用できないためコメントアウト
        let playerState = player.playbackState
        if playerState == MPMusicPlaybackState.playing {
            playerStopEvent()
        } else if playerState == MPMusicPlaybackState.paused || playerState == MPMusicPlaybackState.stopped {
            playerPlayEvent()
        }
         */
        
        if isPlayerPlaying() {
            
            playerStopEvent()
            
        } else {
            
            playerPlayEvent()
            
        }
        
    }
    
    /**
     - TODO
       MPMusicPlayerControllerPlaybackStateDidChangeNotificationが送られてきても、
       その時点では、AVAudioSessionの再生状況に反映されてない という問題が発生するため、
       MPMusicPlayerControllerからの通知を使ってる場合は、その部分で何らかの処理が必要になります。
    */
    func isPlayerPlaying() -> Bool {
        let av = AVAudioSession.sharedInstance()
        return av.isOtherAudioPlaying
    }
    
    /// 再生中か？
    func isMusicPlayerPlaying() -> Bool {
        
        // player.playbackStateは信頼出来ないので、
        // AVAudioSessionで再生状況を調べる
        let av = AVAudioSession.sharedInstance()
        return av.isOtherAudioPlaying
        
    }
    
    // プレイヤー再生イベント処理
    func playerPlayEvent() {
        
        print("player play")
        player.play()
        let image = UIImage(named: "ic_pause_white")
        musicPlayButton.setImage(image, for: .normal)
        
    }
    
    // プレイヤー停止イベント処理
    func playerStopEvent() {
        
        print("player stopped.")
        player.pause()
        let image = UIImage(named: "ic_play_arrow_white")
        musicPlayButton.setImage(image, for: .normal)
        
    }
    
    // MARK: AVSystemPlayer - Notifications
    func systemVolumeDidChange(notification: NSNotification) {
        
        let volume = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float
        volumeSlider.value = volume!
        
    }

    @IBAction func albumSelect(_ sender: Any) {
        
        // 現在のアルバム情報を取得
        /*
        let albumId = player.nowPlayingItem?.albumPersistentID
        let property = MPMediaPropertyPredicate(value: albumId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(property)
        let singles = query.items as! [MPMediaItem]
        
        let imageView = ImageGalleryViewController()
        imageView.mediaQuery = query
        
        for single in singles {
            print(singles)
        }
        */
        
        // DeckTransitionモーダルView
        /*
        let shuffleListTableVC = ShuffleListTableViewController()
        
        let album = albums[selectedMusic!]
        shuffleListTableVC.songs = album.songs
        
        let transitionDelegate = DeckTransitioningDelegate()
        shuffleListTableVC.transitioningDelegate = transitionDelegate
        shuffleListTableVC.modalPresentationStyle = .custom
        present(shuffleListTableVC, animated: true, completion: nil)
 */
        
    }
    
    @IBAction func actionHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
