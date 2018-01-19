//
//  PlayMusicViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/05/02.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import Pastel
import ShadowImageView
import DeckTransition
import KUIPopOver
import WebKit
import PopupDialog
import MarqueeLabel

class PlayMusicViewController: UIViewController {
    
    let playSongs = PlaySongs()
    
    @IBOutlet var musicArtWorkShadow: ShadowImageView!
    @IBOutlet var musicArtWork: UIImageView!
    @IBOutlet var musicArtWorkPlayButton: UIButton!
    @IBOutlet var musicTitle: MarqueeLabel!
    @IBOutlet var musicArtist: UILabel!
    @IBOutlet var musicProgress: UIProgressView!
    @IBOutlet var musicCurrentTime: UILabel!
    @IBOutlet var musicTotalTime: UILabel!
    
    @IBOutlet var musicPlayButton: UIButton!
    @IBOutlet var musicRepeatButton: UIButton!
    @IBOutlet var musicShuffleButton: UIButton!
    
    @IBOutlet var volumeSlider: UISlider!
    private var systemVolumeSlider: UISlider!
    
    var query: MPMediaQuery = MPMediaQuery()
    var queryItems: [MPMediaItem] = []
    var singles: [MPMediaItem] = []
    var selectedIndex: Int?
//    var musicId: MPMediaEntityPersistentID = MPMediaEntityPersistentID()
    var playlistId = MPMediaPlaylistPropertyPersistentID
    var isPlaying: Bool?
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var song: MPMediaItem = MPMediaItem()
    
    var player = MPMusicPlayerController.systemMusicPlayer
    var avAudioPlayer = AVAudioPlayer()
    var time = Timer()
    var currentTime: Double = 0.0
    var currentTimeInt: Int = 0
    var totalTime: Double = 0.0
    var totalTimeInt: Int = 0
    
    var playlistsName: String = ""
    var playlistsIndex: Int = 0
    var playMusicTitle: String = ""
    
//    let songsMediaQuery = MPMediaQuery.songs()
//    var playlistsMediaQuery = MPMediaQuery.playlists()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        // 再生中のItemが変わった時に通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(PlayMusicViewController.nowPlayingItemChanged(_:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
        
//        notificationCenter.addObserver(self, selector: #selector(PlayMusicViewController.nowPlayingItemChanged(_:))
//            , name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知の有効化
//        player.beginGeneratingPlaybackNotifications()
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //　TODO ローディング画面入れる？
        
        // TODO 再生中の曲だったら選曲をスキップする
        // 再生中に遷移された場合は、再生を止めずに再生曲の情報を表示
        if (self.selectedIndex != nil) {
            
            player.stop()
            
            //        player.nowPlayingItem = query.items?[selectedIndex]
            //        player.nowPlayingItem = singles[selectedIndex]
            if queryItems.count != 0 {
                
                if playlistsName.count != 0 {
                    
                    let property = MPMediaPropertyPredicate(value: playlistsName, forProperty: MPMediaPlaylistPropertyName)
                    query.addFilterPredicate(property)
                    player.setQueue(with: query)
                    player.nowPlayingItem = query.items?[selectedIndex!]
                    print("再生する曲は：" + (query.items?[selectedIndex!].title!)!)
                    playerPlayEvent()
                } else {
                    print("再生する曲は：" + queryItems[selectedIndex!].title!)
                    
                    //        let collection = MPMediaItemCollection(items: query.items!) //it needs the "!"
                    let collection = MPMediaItemCollection(items: queryItems) //it needs the "!"
                    player.setQueue(with: collection)
                    player.nowPlayingItem = collection.items[selectedIndex!]
                    playerPlayEvent()
                    
                }
            } else {
                player.setQueue(with: MPMediaQuery.songs())
                player.nowPlayingItem = MPMediaQuery.songs().items?[0]
                playerPlayEvent()
            }
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // バックグラウンドグラデーションを有効
        addPastelBackground()
        
        // 再生中ボタンからか？
//        let vc = ImageGalleryViewController()
//        vc.isNowPlayButton = false
        
        // 再生中か？
//        isPlaying = isPlayerPlaying()
    

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
    
    
    @objc func nowPlayingItemChanged(_ notification: NSNotification) {
        
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        
    }
    
    /**
     - 曲情報を表示する
    */
    func updateSongInformationUI(mediaItem: MPMediaItem) {
        
        // 再生時間を表示
//        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        
//        musicProgress.setProgress(Float((player.nowPlayingItem?.playbackDuration)!), animated: true)
        
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
        
        // Continuous Type
        musicTitle.type = .continuous
        musicTitle.animationCurve = .easeInOut
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: musicArtWork.bounds.size)
            musicArtWorkShadow.image = image
//            musicArtWork.image = image
        } else {
            // アートワークがないとき(灰色表示)
            musicArtWork.image = UIImage(named: "album1")
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
     - 再生時間を更新
    */
    func updateElapsedTime() {
        currentTime = player.currentPlaybackTime
        
        if !currentTime.isNaN {
            currentTimeInt = Int(currentTime)
            let min = currentTimeInt / 60
            let sec = currentTimeInt % 60
            musicCurrentTime.text = String(format: "%02d:%02d", min, sec)
    
            totalTime = (player.nowPlayingItem?.playbackDuration)!
            totalTimeInt = Int(totalTime)
            var totalMin = (totalTimeInt - currentTimeInt) / 60
            var totalSec = (totalTimeInt - currentTimeInt) % 60
            musicTotalTime.text = String(format: "%02d:%02d", totalMin, totalSec)
    
            // プログレスバーの進捗状況を反映（現在の再生時間／曲の再生時間）
            musicProgress.progress = Float(currentTime) / Float(totalTime)
        }
        
    }
    
    
    /**
     - タップイベント
    */
    @objc func singleTap(sender: UITapGestureRecognizer) {
        print("single Tap!")
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        print("double Tap!")
        // SongListTableView
        /*
        let songListTableVC = SongListTableViewController()
        songListTableVC.modalPresentationStyle = .overCurrentContext
        songListTableVC.view.backgroundColor = UIColor.clear
        present(songListTableVC, animated: true, completion: nil)
        */
        
        // DeckTransitionモーダルView
        let modal = SongListTableViewController()
        let transitionDelegate = DeckTransitioningDelegate()
        
        let property = MPMediaPropertyPredicate(value: playlistsName, forProperty: MPMediaPlaylistPropertyName)
        query.addFilterPredicate(property)
        modal.mediaQuery = query
        
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        present(modal, animated: true, completion: nil)
        
    }
    
    
    /**
     - スワイプイベント
    */
    internal func swipeGesture(sender: UISwipeGestureRecognizer){
        let touches = sender.numberOfTouches
        print("\(touches)")
    }
    
    @objc func handleSwipeUp(sender: UITapGestureRecognizer) {
        
        playerPlayEvent()
        
        // アニメーション実行
        let newImage = UIImage(named: "ic_play_arrow_white")
        imageCenterShow(image: newImage!)
        
        print("Swiped Up!!!")
        
    }
    
    @objc func handleSwipeDown(sender: UITapGestureRecognizer) {
        
        playerStopEvent()
        
        // アニメーション実行
        let newImage = UIImage(named: "ic_pause_white")
        imageCenterShow(image: newImage!)
        
        print("Swiped Down!!!")
        
    }
    
    @objc func handleSwipeLeft(sender: UITapGestureRecognizer) {
        
        player.skipToPreviousItem()
        
        // アニメーション実行
        let newImage = UIImage(named: "icons8-Back")
        imageCenterShow(image: newImage!)
        
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
    
    @objc func handleSwipeRight(sender: UITapGestureRecognizer) {
        
        player.skipToNextItem()
        
        // アニメーション実行
        let newImage = UIImage(named: "icons8-Forward")
        imageCenterShow(image: newImage!)
        
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
       MPMusicPlayerControllerからの通知を使ってる場合は、その部分で何らかの処理が必要
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
    
    // 渡された画像を画面中央にアニメーション表示する
    func imageCenterShow(image: UIImage) {
        
        
        let imageView = UIImageView(image: image)
        
        // 画面の縦横幅を取得
        let screenHeight:CGFloat = view.frame.size.height
        let screenWidth:CGFloat = view.frame.size.width
        
        imageView.frame = CGRect(x: 0, y: screenHeight / 2, width: screenWidth / 3, height: screenWidth / 3)
        //画面中心に画像を設定
        imageView.center.x = self.view.center.x
        //imageView.center.y = self.view.center.y
        
        // UIImageViewのインスタンスをビューに追加
        self.view.addSubview(imageView)
        
        
        
        //画像縮小の場合
        //        let screenWidthScale:CGFloat = self.view.bounds.width * 0.8 // 画像の大きさに対して0.8倍
        //        let scale:CGFloat = screenWidthScale / newImage!.size.width
        
        //        tmpImageView.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: (newImage?.size.width)! * scale, height: (newImage?.size.height)! * scale)
        
        //インスタンスビューに表示して一番前に表示
        //        self.view.addSubview(tmpImageView)
        //        self.view.bringSubview(toFront: tmpImageView)
        
        
        
        
        //        self.view.addSubview(tmpImageView)
        //        tmpImageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        //        tmpImageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            imageView.alpha = 0
        }) { _ in
            imageView.removeFromSuperview()
        }
        
    }

    @IBAction func albumSelect(_ sender: UIButton) {
        
        // 現在のアルバム情報を取得
        
        // PopOverView
        //Prepare the instance of ContentViewController which is the content of popover.
        /*
        let playSinglesListVC = PlaySinglesListViewController()
        let albumID = player.nowPlayingItem?.albumPersistentID
        let property = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(property)
        playSinglesListVC.songs = query.items!
        
        let transitionDelegate = DeckTransitioningDelegate()
        playSinglesListVC.transitioningDelegate = transitionDelegate
        playSinglesListVC.modalPresentationStyle = .custom
        present(playSinglesListVC, animated: true, completion: nil)
        */
        
        // DeckTransitionモーダルView
        /*
        let shuffleListTableVC = ShuffleListTableViewController()
        let albumID = player.nowPlayingItem?.albumPersistentID
        let property = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(property)
        shuffleListTableVC.songs = query.items!
        
        let transitionDelegate = DeckTransitioningDelegate()
        shuffleListTableVC.transitioningDelegate = transitionDelegate
        shuffleListTableVC.modalPresentationStyle = .custom
        present(shuffleListTableVC, animated: true, completion: nil)

        // KUIPopOverView
        
        let customViewController = CustomPopOverTableViewController()
        
        customViewController.showPopover(sourceView: sender, sourceRect: sender.bounds)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            customViewController.dismissPopover(animated: true)
        }
        
        */
        
        // Create our custom view controller programatically
//        let vc = PopupTableViewController(nibName: nil, bundle: nil)
        let playSinglesListVC = PlaySinglesListViewController()
        
        // Create the PopupDialog with a completion handler,
        // called whenever the dialog is dismissed
        let popup = PopupDialog(viewController: playSinglesListVC, gestureDismissal: false) {
//            guard let city = vc.selectedCity else { return }
//            print("User selected city: \(city)")
        }
        
        
        let albumID = player.nowPlayingItem?.albumPersistentID
        let property = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(property)
        playSinglesListVC.songs = query.items!

        // Create a cancel button for the dialog,
        // including a button action
        let cancel = DefaultButton(title: "Cancel") {
            print("User did not select a city")
        }
        
        // Add the cancel button we just created to the dialog
        popup.addButton(cancel)
        
        // Moreover, we set a list of cities on our custom view controller
//        vc.cities = ["Munich", "Budapest", "Krakow", "Rome", "Paris", "Nice", "Madrid", "New York", "Moscow", "Peking", "Tokyo"]
        
        // We also pass a reference to our PopupDialog to our custom view controller
        // This way, we can dismiss and manipulate it from there
        playSinglesListVC.popup = popup
        
        // Last but not least: present the PopupDialog
        present(popup, animated: true, completion: nil)
        
        
        
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController)
    {
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
    
    @IBAction func actionHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func musicArtWorkPlayButton(_ sender: Any) {
        playerPlayEvent()
    }
    
}

class DefaultPopOverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        popoverPresentationController?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

class CustomPopOverView: UIView, KUIPopOverUsable {
    
    var contentSize: CGSize {
        return CGSize(width: 300.0, height: 400.0)
    }
    
    var arrowDirection: UIPopoverArrowDirection {
        return .none
    }
    
    lazy var webView: WKWebView = {
        let webView: WKWebView = WKWebView(frame: self.frame)
        webView.load(URLRequest(url: URL(string: "http://github.com")!))
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(webView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = self.bounds
    }
    
}


class CustomPopOverTableViewController: UITableViewController, KUIPopOverUsable {
    
    var uiTableView = UITableView()
    var items: [String] = ["Cat", "Dog", "Bird"]
    
    var contentSize: CGSize {
        return CGSize(width: 300.0, height: 400.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTableView.frame = UIScreen.main.bounds
        uiTableView.delegate = self
        uiTableView.dataSource = self
        // uiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        uiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "albumSelectCell")
        
        self.view.addSubview(uiTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        uiTableView.frame = view.bounds
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSelectCell", for: indexPath as IndexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        print(self.items[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
    }
    
}
