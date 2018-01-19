//
//  AlbumsTableViewController.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/16.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import Foundation
import MediaPlayer
import XLPagerTabStrip

class AlbumsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var collections: [MPMediaItemCollection] = MPMediaQuery.albums().collections!
    var collectionSections: [MPMediaQuerySection] = MPMediaQuery.albums().collectionSections!
    var collectionSectionTitles: [String] = []
    var query = MPMediaQuery.albums()
    
    var songInfoDic = [String: String]()
    var artistNameList: [String] = []
    var albumTitleList: [String] = []
    var albumArtworkImageList: [MPMediaItemArtwork] = []
    var albumPersistentIdList: [MPMediaEntityPersistentID] = []
    
    let cellIdentifier = "AlbumCell"
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
        
        self.collections = query.collections!
        self.collectionSections = query.collectionSections!
        
        for section in self.collectionSections {
            self.collectionSectionTitles.append(section.title)
        }
        
        // XLPagerTabStripとセルの間に出来る謎のマージンを解消
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
    
        /*
        let albumItem = albumsQuery.collections as! [MPMediaItemCollection]
        for item in albumItem {
            
            let artistName = item.representativeItem?.albumArtist ?? item.representativeItem?.artist
            let albumTitle = item.representativeItem?.albumTitle ?? item.representativeItem?.title
            artistNameList.append(artistName!)
            albumTitleList.append(albumTitle!)
            if let artwork = item.representativeItem?.artwork {
                albumArtworkImageList.append(artwork)
            } else {
                let defaultImage = UIImage(named: "album1")
                albumArtworkImageList.append(MPMediaItemArtwork(image: defaultImage!))
            }
            albumPersistentIdList.append((item.representativeItem?.albumPersistentID)!)
            
            songInfoDic[artistName!] = albumTitle
            print(artistName! + ":" + albumTitle!)
            
        }
        */
        
        // artistNameの配列を取得
//        artistNameList = Array(songInfoDic.keys)  //  [sex, name, age]
        // albumTitleの配列を取得
//        albumTitleList = Array(songInfoDic.values) //  [man, hachinobu, 28]
        
        self.tableView.allowsSelection = true
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // セクション名の配列を返す
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let sectionIndexTitles = albumsQuery.itemSections!.map { $0.title }
//        return sectionIndexTitles
        return self.collectionSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    // セクション名を返す
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return (albumsQuery.itemSections![section].title)
        let section = self.collectionSections[section]
        return section.title
    }
    
    // セクションの個数を返す
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return (albumsQuery.itemSections?.count)!
        return self.collectionSections.count
    }
    
    // データの個数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return albumsQuery.collectionSections![section].range.length
//        return allAlbums.count
        let section = self.collectionSections[section]
        return section.range.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlbumCell
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArtistCell,
//            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }
//        cell.configureWithData(data)
//        if blackTheme {
//            cell.changeStylToBlack()
//        }
//        cell.subLabel.text = artistNameList[indexPath.row]
//        cell.mainLabel.text = albumTitleList[indexPath.row]
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
        let song = rowItem.representativeItem
        
        cell.mainLabel.text = song?.value(forKey: MPMediaItemPropertyAlbumTitle) as! String
        cell.subLabel.text = song?.value(forKey: MPMediaItemPropertyArtist) as! String
        
        let artwork = song?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        // artworkImage に UIImage として保持されている
        if let artwork = artwork, let artworkImage = artwork.image(at: artwork.bounds.size) {
            cell.artworkImage.image = artworkImage
        }
        
        /*
        let currentLocation = albumsQuery.collectionSections![indexPath.section].range.location
        let rowItem = albumsQuery.collections![indexPath.row + currentLocation]
        
        cell.mainLabel.text = rowItem.items[0].albumTitle
        cell.subLabel.text = rowItem.items[0].albumArtist
        
        // アートワーク表示
//        if let artwork = albumArtworkImageList[indexPath.row] as? MPMediaItemArtwork {
        if let artwork = rowItem.items[0].artwork {
            let image = artwork.image(at: cell.bounds.size) as? UIImage
            // アートワークを丸抜きイメージにする
//            cell.artworkImage.layer.cornerRadius = cell.artworkImage.frame.width / 2
//            cell.artworkImage.clipsToBounds = true
            cell.artworkImage.image = image
        }
        */
        
        
//        cell.artworkImage.image = albumArtworkImageList[indexPath.row] as? UIImage
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.collectionSections[indexPath.section];
        let rowItem = self.collections[section.range.location + indexPath.row];
        
        let albumsDetailVC = AlbumsDetailTableViewController()
        albumsDetailVC.albumTitle = (rowItem.representativeItem?.albumTitle)!
        albumsDetailVC.artistName = (rowItem.representativeItem?.albumArtist)!
        albumsDetailVC.albumPersistentId = (rowItem.representativeItem?.albumPersistentID)!
        
        self.navigationController?.pushViewController(albumsDetailVC, animated: true)
//        let navigationController = UINavigationController(rootViewController: albumsDetailVC)
//        present(navigationController, animated: true, completion: nil)
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension MPMediaQuery {
    public static func albumsAll() -> MPMediaQuery {
        let query = MPMediaQuery.songs()
        query.groupingType = MPMediaGrouping.album
        return query
    }
}
