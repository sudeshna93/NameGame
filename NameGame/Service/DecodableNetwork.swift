//
//  DecodableNetwork.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/20/22.
//

import Foundation


class DecodableNetwork {
    //MARK: Properties
    var decoder = JSONDecoder()
    var session : URLSession
    
    //keep track of existing tasks
    var currentTasks : [URL:URLSessionDataTask] = [:]
    
    //MARK: Designated Initializer
    init(_ session: URLSession, _ decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    init(_ session: URLSession) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    //MARK:Networking methods
    func getData(_ url: URL, _ completion: @escaping (Data?)->Void){
        //cancel an existing task if already enqueued a task
        cancelTask(url)
        
        let task = URLSession.shared.dataTask(with: url) { (dat, _, _) in
            completion(dat)
        }
        //keep track of that new task
        currentTasks[url] = task
        
        task.resume()
        
        //artificial delay for 2 seconds
//        let delay = Double.random(in: 0.5...2.0)
//        let dispatchTask: ()->Void = {
//            task.resume()
//        }
        
      //  DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: dispatchTask)
    }
    
    
    func cancelTask(_ url : URL){
        if let curr = currentTasks[url]{
            curr.cancel()
        }
    }
    
    func get<T: Decodable>(type: T.Type, url: URL, _ completion: @escaping (T?) ->Void) {
        
        session.dataTask(with: url) { (data, resp, _) in
            guard let data = data else { return }
            do {
                let result  = try self.decoder.decode(type,from: data)
                completion(result)
                print(result)
            }
            catch{
                completion(nil)
                print(error)
            }
        }.resume()
    }
    
}

extension DecodableNetwork{
    convenience init() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.init(session)
    }
    
    convenience init(_ config: URLSessionConfiguration) {
        let session = URLSession(configuration: config)
        self.init(session)
    }
}
