//
//  Comics.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 02/03/2023.
//

import Foundation

struct ComicDataResponse: Hashable, Decodable {
    let data: ComicData
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct ComicData: Hashable, Decodable {
    let count: Int
    let results: [Comic]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}

struct Comic: Hashable, Decodable, CollectionItem {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let thumbnail: MCImage
    let creators: CreatorList

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case resourceURI
        case thumbnail
        case creators
    }
}
