//
//  ArtistsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/12.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import XLPagerTabStrip

class ArtistsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var playSongs = PlaySongs()
    
    var collections: [MPMediaItemCollection] = MPMediaQuery.artists().collections!
    var collectionSections: [MPMediaQuerySection] = MPMediaQuery.artists().collectionSections!
    var collectionSectionTitles: [String] = []
    
    var artistNameList: [String] = []
    let cellIdentifier = "ArtistCell"
    var blackTheme = false
//    var itemInfo = IndicatorInfo(title: "View")
    var itemInfo: IndicatorInfo = "View"

    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSongs.query = MPMediaQuery.artistsAll()
        self.collections = (playSongs.query?.collections!)!
        self.collectionSections = (playSongs.query?.collectionSections!)!
        
        print(UserDefaults.standard.dictionaryRepresentation())
        
//        playSongs.songs = query.items
//        self.collections = query.collections!
//        self.collectionSections = query.collectionSections!
        
        for section in self.collectionSections {
            self.collectionSectionTitles.append(section.title)
        }
        
        // XLPagerTabStripとセルの間に出来る謎のマージンを解消
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        
        tableView.register(UINib(nibName: "ArtistCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
    
        /*
        let artistItem = artistsQuery.collections!
        for item in artistItem {
            let artist = item.representativeItem?.artist ?? ""  // アーティスト名
            artistNameList.append(artist)
        }
         */
        self.tableView.allowsSelection = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        artistsQuery = MPMediaQuery.artists()
        
        tableView.reloadData()
    }
    
    
    // データを返す
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ArtistCell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArtistCell,
//            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
//        cell.configureWithData(data)
//        if blackTheme {
//            cell.changeStylToBlack()
//        }
//        *** cell.artistName.text = artistNameList[indexPath.row]
        
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
        let song = rowItem.representativeItem
        
//        cell.postName.text = song?.value(forKey: MPMediaItemPropertyTitle) as! String
        cell.artistName.text = song?.value(forKey: MPMediaItemPropertyArtist) as! String
        
        let artwork = song?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        // artworkImage に UIImage として保持されている
        if let artwork = artwork, let artworkImage = artwork.image(at: artwork.bounds.size) {
            // アートワークを丸抜きイメージにする
            cell.artistImage.layer.cornerRadius = cell.artistImage.frame.width / 2
            cell.artistImage.clipsToBounds = true
            cell.artistImage.image = artworkImage
        }
        
        
        
//        let currentLocation = artistsQuery.collectionSections![indexPath.section].range.location
//        let rowItem = artistsQuery.collections![indexPath.row + currentLocation]
        
//        cell.artistName.text = rowItem.items[0].albumArtist
        
        //Main text is Album name
//        cell.textLabel!.text = rowItem.items[0].albumTitle
        // Detail text is Album artist
//        cell.detailTextLabel!.text = rowItem.items[0].albumArtist!
        // Or number of songs from the current album if you prefer
        //cell.detailTextLabel!.text = String(rowItem.items.count) + " songs"
        
        // Add the album artwork
//        var artWork = rowItem.representativeItem?.artwork
//        let tableImageSize = CGSize(width: 10, height: 10) //doesn't matter - gets resized below
//        let cellImg: UIImageView = UIImageView(frame: CGRectMake(0, 5, myRowHeight-10, myRowHeight-10))
//        cellImg.image = artWork?.image(at: tableImageSize)
//        cell.addSubview(cellImg)
        
        
        return cell
    }

    // セクション名の配列を返す
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let sectionIndexTitles = artistsQuery.itemSections!.map { $0.title }
//        return sectionIndexTitles
        return self.collectionSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        print("インデックス" + String(index))
        return index
    }

    // セクション名を返す
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print(artistsQuery.itemSections![section].title)
//        return (artistsQuery.itemSections![section].title)
        let section = self.collectionSections[section]
        return section.title
    }
    
    // セクションの個数を返す
    override func numberOfSections(in tableView: UITableView) -> Int {
//        print(artistsQuery.itemSections?.count)
//        return (artistsQuery.itemSections?.count)!
        return self.collectionSections.count
    }
    
    // データの個数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allArtists.count
//        return artistsQuery.collectionSections![section].range.length
        let section = self.collectionSections[section]
        return section.range.length
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let artistDetailVC = ArtistDetailTableViewController()
//        artistDetailVC.artistName = artistNameList[indexPath.row]
//        let navigationController = UINavigationController(rootViewController: artistDetailVC)
//        present(navigationController, animated: true, completion: nil)
        
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
        
        let artistItemsVC = ArtistItemsTableViewController()
//        artistItemsVC.itemCollection = rowItem
        artistItemsVC.artistName = (rowItem.representativeItem?.artist)!
//        let navigationController = UINavigationController(rootViewController: artistItemsVC)
        self.navigationController?.pushViewController(artistItemsVC, animated: true)
//        present(navigationController, animated: true, completion: nil)
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension MPMediaQuery {
    public static func artistsAll() -> MPMediaQuery {
        let query = MPMediaQuery.artists()
        query.groupingType = MPMediaGrouping.artist
        return query
    }
}
