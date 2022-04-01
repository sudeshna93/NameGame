//
//  EmployeeController.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/21/22.
//

import Foundation


protocol EmployeeControllerProtocol {
    var employees: [Name] {get}
    func download(_ completion: @escaping ([Name])->Void)
    func getPicture(_ url:URL, _ completion: @escaping (Data?)->Void)
    func cancelTask(_ oldURL: URL)
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) 
}

class EmployeeController: EmployeeControllerProtocol {
    
    //MARK:Properties
    let networker = DecodableNetwork()
    var employees : [Name] = []
   
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    
    //MARK:METHODS
    //Function for downloading employee details
    func download(_ completion: @escaping ([Name])->Void) {
        if let url = URL(string: "https://namegame.willowtreeapps.com/api/v1.0/profiles"){
            networker.get(type: [Name].self, url: url) { (result) in
                print("finished download")
                
                if let rslt = result{
                    self.employees = rslt
                }
               
                completion(self.employees)
            }
        }
    }
    
    func getPicture(_ url: URL, _ completion: @escaping (Data?) -> Void) {
        pictureService.get(url,completion)
    }
    
    func cancelTask(_ oldURL: URL) {
        networker.cancelTask(oldURL)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    }
