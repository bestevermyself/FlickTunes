//
//  ParentViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/09.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip
import Floaty
import MediaPlayer

class ParentViewController: ButtonBarPagerTabStripViewController {

    var isReload = false
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    let purpleColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 0.5)
    let midNightBlue = UIColor(red: 0, green: 0.0627, blue: 0.549, alpha: 1.0)
    
    private var floatingButton: UIButton!
    
    override func viewDidLoad() {
        // set up style before super view did load is executed
        settings.style.buttonBarBackgroundColor = midNightBlue
        settings.style.selectedBarBackgroundColor = .orange
        settings.style.selectedBarHeight = 2.0
        
        super.viewDidLoad()
        
        let floaty = Floaty()
        floaty.addItem("Play Songs", icon: UIImage(named: "icon")!, handler: { item in
//            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
            
            // 名前を指定して Storyboard を取得する(Main.storyboard の場合)
            let storyboard = UIStoryboard(name: "PlayMusic", bundle: nil)
            // 「is initial view controller」が設定されている ViewController を取得する
            let playMusicVC = storyboard.instantiateInitialViewController() as! PlayMusicViewController
            
            // 再生中であれば再生している曲情報を表示
            if (!playMusicVC.isMusicPlayerPlaying()) {
                
                // ここは不必要かも？
                let query = MPMediaQuery.songs()
                playMusicVC.queryItems = query.items!
                playMusicVC.query = query
                
            }
            
            self.present(playMusicVC, animated: true, completion: nil)
            floaty.close()
        })
        
        floaty.addItem("Play Shuffle", icon: UIImage(named: "icon")!, handler: { item in
            let alert = UIAlertController(title: "再生", message: "シャッフル再生します", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        })
        floaty.addItem("Setting", icon: UIImage(named: "icon")!, handler: { item in
            let alert = UIAlertController(title: "設定", message: "設定画面に遷移", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            floaty.close()
        })
        self.view.addSubview(floaty)
        
        
        // Do any additional setup after loading the view.
        // change selected bar color
        /*
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {
            [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                guard changeCurrentIndex == true else { return }
                oldCell?.label.textColor = .black
                newCell?.label.textColor = self?.purpleInspireColor
        }
        */
        
//        createPlayMusicViewButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // ナビバーの表示を切り替える
        if let nv = navigationController {
            let hidden = !nv.isNavigationBarHidden
            nv.setNavigationBarHidden(hidden, animated: true)
        }
        
        
//        buttonBarView.removeFromSuperview()
//        navigationController?.navigationBar.addSubview(buttonBarView)

        changeCurrentIndexProgressive = {
            (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white

            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }

        self.view.layoutIfNeeded()
        buttonBarView.frame.origin.y = UIApplication.shared.statusBarFrame.size.height
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /**
    - Floatingボタンを生成する
    **/
    func createPlayMusicViewButton () {
       
        // Buttonを生成する
        floatingButton = UIButton()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // ボタンのサイズ
        let bWidth: CGFloat = 80
        let bHeight: CGFloat = 80
        
        // ボタンのX,Y座標
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/2 - bWidth/2
        
        // ボタンの設置座標とサイズを設定する
        floatingButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        
        // ボタンの背景色を設定
        floatingButton.backgroundColor = UIColor.red
        
        // ボタンの枠を丸くする
        floatingButton.layer.masksToBounds = true
        
        // コーナーの半径を設定する
        floatingButton.layer.cornerRadius = bHeight/2
        
        // タイトルを設定する(通常時)
        floatingButton.setImage(UIImage(named:"ic_play_arrow_white"), for: .normal)
//        myButton.setTitle("ボタン(通常)", for: .normal)
//        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
//        myButton.setTitle("ボタン(押された時)", for: .highlighted)
//        myButton.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける
        floatingButton.tag = 1
        
        // イベントを追加する
//        myButton.addTarget(self, action: #selector(viewControllers.onClickMyButton(sender:)), for: .touchUpInside)
        
        // ボタンをViewに追加
        self.view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(presentPlayMusicView(sender:)), for: .touchUpInside)
        
        // AutoLayout制約を設定
        floatingButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30.0).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 30.0).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30.0).isActive = true
        
    }
    
    @objc func presentPlayMusicView(sender: UIButton) {
        
        let playMusicVC = PlayMusicViewController()
        present(playMusicVC, animated: true, completion: nil)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
//        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
//        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "player")
//        let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "table")
        let child_1 = PlaylistsTableViewController(style: .grouped, itemInfo: "Playlists")
        let child_2 = ArtistsTableViewController(style: .grouped, itemInfo: "Artists")
        let child_3 = AlbumsTableViewController(style: .grouped, itemInfo: "Albums")
        let child_4 = MusicsTableViewController(style: .grouped, itemInfo: "Musics")
        let child_5 = PlaysTableViewController(style: .grouped, itemInfo: "Plays")
        
        
        guard isReload else {
            return [child_1, child_2, child_3, child_4, child_5]
        }

        var childViewControllers = [child_1, child_2, child_3, child_4, child_5]

        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
        
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }

    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        super.configureCell(cell, indicatorInfo: indicatorInfo)
        cell.backgroundColor = .clear
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}
