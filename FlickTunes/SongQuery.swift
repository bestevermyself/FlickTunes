//
//  SongItem.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/05/28.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import MediaPlayer

public var selectedMusic: Int? {
    get {
        return UserDefaults.standard.object(forKey: "selectedMusic") as? Int
    }
    set {
        UserDefaults.standard.set(newValue!, forKey: "selectedMusic")
        UserDefaults.standard.synchronize()
    }
}
 
struct SongInfo {
    var title: String
    var album: String
    var artist: String
//    var artwork: MPMediaItemArtwork
    var persistentID: NSNumber
//    var genre: String
//    var playCount: UInt64
    
    /*
    init(title: String, album: String, artist: String, persistentID: NSNumber) {
        self.title = title
        self.album = album
        self.artist = artist
//        self.artwork = artwork
        self.persistentID = persistentID
//        self.genre = genre
//        self.playCount = playCount
    }
    */
}

// アルバム情報
struct AlbumInfo {
    
    var albumTitle: String
    var albumJacket: UIImage
    var songs: [SongInfo]
    
//    init() {
//        self.albumTitle = "不明"
//        self.albumJacket = UIImage()
//        self.songs = []
//    }
    
}

class SongQuery {
    
    // iPhoneに入ってる曲を全部返す
    func get() -> [AlbumInfo] {
        
        var albums: [AlbumInfo] = []
        
        // アルバム情報から曲を取り出す
        let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        var albumItems: [MPMediaItemCollection] = albumsQuery.collections as! [MPMediaItemCollection]
        var album: MPMediaItemCollection
        
        for album in albumItems {
            
            var albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            var song: MPMediaItem
            
            var songs: [SongInfo] = []
            
            var albumTitle: String = ""
            let jacketNone: UIImage = UIImage(named: "music")!
            var albumJacket: UIImage = UIImage(named: "music")!
            
            for song in albumItems {
                
//                let artwork: MPMediaItemArtwork = song.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
//                let jacketImage: UIImage = artwork.image(at: artwork.bounds.size)!
//                albumJacket = [jacketImage as! MPMediaItemArtwork]
                
                albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                var artwork = song.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork  // ジャケット
                
                albumJacket = jacketNone
                if var artwork = artwork, let artworkImage = artwork.image(at: artwork.bounds.size) {
                    // artworkImage に UIImage として保持されている
                    albumJacket = artworkImage
                }
                
                let songInfo: SongInfo = SongInfo(
                    title:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
                    album: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
                    artist: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
//                    artwork: artwork!,
                    persistentID: song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
                )
                
                songs.append( songInfo )
            }
            
            let albumInfo: AlbumInfo = AlbumInfo(
                
                albumTitle: albumTitle,
                albumJacket: albumJacket,
                songs: songs
            )
            
            albums.append( albumInfo )
        }
        
        return albums
        
    }
    
    // songIdからMediaItemを取り出す
    func getItem( songId: NSNumber) -> MPMediaItem {
        
        var property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        var query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items as! [MPMediaItem]
        
        return items[items.count - 1]
        
    }
    
}
