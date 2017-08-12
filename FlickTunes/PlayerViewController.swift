//
//  PlayerViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/11.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MediaPlayer

class PlayerViewController: UIViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Player")
    }
    
    @IBAction func player(_ sender: Any) {
        
//        let property = MPMediaPropertyPredicate(value: "LinQ", forProperty: MPMediaItemPropertyArtist)
//        let query = MPMediaQuery()
//        query.addFilterPredicate(property)
//        let singles = query.items!
//        let mediaItems = singles
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
