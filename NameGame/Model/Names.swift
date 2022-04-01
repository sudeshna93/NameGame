//
//  Names.swift
//  NameGame
//
//  Created by Arnab Sudeshna on 3/20/22.
//

import Foundation


struct Name: Decodable,Equatable{
    let firstname : String?
    let lastname: String?
    let headShot : HeadShot
    
    enum CodingKeys: String, CodingKey {
        case firstname = "firstName"
        case headShot = "headshot"
        case lastname = "lastName"
    }
}

struct HeadShot : Decodable,Equatable {
    let url : String?
    
    
    enum CodingKeys : String, CodingKey {
        case url = "url"
    }
}
