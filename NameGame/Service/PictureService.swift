//
//  PictureService.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/20/22.
//

import Foundation

class PictureService {
    //MARK:properties
    let cache : NSCache<NSURL, NSData>
    let networker: DecodableNetwork
    
    //MARK:Initializer
    init(_ networker: DecodableNetwork) {
        cache = NSCache()
        self.networker = networker
    }
    
    
    //MARK: Picture access method
    func get(_ url: URL, _ completion: @escaping(Data?)->Void) {
        //if I have it in the cache return this value
        if let nsUrl = NSURL(string: url.absoluteString),
           let val = cache.object(forKey: nsUrl){
            let data = Data(referencing: val)
            completion(data)
            return
        }
        
        //otherwise fetch it from network
        networker.getData(url) { (data) in
            if let data = data,
               let nsURL = NSURL(string: url.absoluteString){
                let nsData = NSData(data: data)
                self.cache.setObject(nsData, forKey: nsURL)
            }
            completion(data)
        }
    }
}
