//
//  ArtistsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/12.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import MediaPlayer
import XLPagerTabStrip

class ArtistsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var artistNameList: [String] = []
    let cellIdentifier = "ArtistCell"
    var blackTheme = false
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
        
        tableView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        
    
        let artistsQuery = MPMediaQuery.artists()
        let artistItem = artistsQuery.collections as! [MPMediaItemCollection]
        for item in artistItem {
            let artist = item.representativeItem?.artist ?? ""  // アーティスト名
            artistNameList.append(artist)
        }
        self.tableView.allowsSelection = true
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return DataProvider.sharedInstance.postsData.count
        return artistNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArtistCell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArtistCell,
//            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
//        cell.configureWithData(data)
//        if blackTheme {
//            cell.changeStylToBlack()
//        }
        cell.artistName.text = artistNameList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistDetailVC = ArtistDetailTableViewController()
        artistDetailVC.artistName = artistNameList[indexPath.row]
        let navigationController = UINavigationController(rootViewController: artistDetailVC)
        present(navigationController, animated: true, completion: nil)
//        navigationController?.present(artistDetailVC, animated: true, completion: nil)
//        present(artistDetailVC, animated: true, completion: nil)
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
