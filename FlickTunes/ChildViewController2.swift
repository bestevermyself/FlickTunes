//
//  ChildViewController2.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/09.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ChildViewController2: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"

    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XLPagerTabStrip"

        view.addSubview(label)
        view.backgroundColor = .orange
        
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -50))
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Child 2")
    }

}
