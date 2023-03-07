//
//  Series.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 03/03/2023.
//

import Foundation

struct ApiResponse: Decodable, Hashable {
    let copyright: String
    let data: DataResponse

    enum CodingKeys: String, CodingKey {
        case copyright, data
    }
}


struct DataResponse: Decodable, Hashable {
    let count: Int
    let results: [MCCollectionItem]
    
    enum CodingKeys: String, CodingKey {
        case count, results
    }
}


struct MCCollectionItem: Decodable, Hashable {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let thumbnail: MCImage
    let creators: CreatorList
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, resourceURI, thumbnail, creators
    }
}
