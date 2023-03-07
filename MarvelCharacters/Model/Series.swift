//
//  Series.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 03/03/2023.
//

import Foundation

struct SeriesDataResponse: Decodable, Hashable {
    let copyright: String
    let data: SeriesData

    enum CodingKeys: String, CodingKey {
        case copyright, data
    }
}

struct SeriesData: Decodable, Hashable {
    let count: Int
    let results: [Series]
    
    enum CodingKeys: String, CodingKey {
        case count, results
    }
}

struct Series: Decodable, Hashable, CollectionItem {
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
