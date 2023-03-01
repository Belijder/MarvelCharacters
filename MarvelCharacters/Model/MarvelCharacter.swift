//
//  MarvelCharacter.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 24/02/2023.
//

import Foundation

struct APIResponse: Codable {
    let code: Int
    let status: String
    let data: CharacterDataWrapper
    
    enum CodingKeys: String, CodingKey {
        case code, status, data
    }
}


struct CharacterDataWrapper: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count, results
    }
}


struct MarvelCharacter: Codable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: Thumbnail
    let comics: ComicList
    let series: SeriesList
    let stories: StoryList
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, comics, series, stories
    }
}


struct Thumbnail: Codable, Hashable {
    let path: String
    let `extension`: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }
}


struct ComicList: Codable, Hashable {
    let available: Int
    let collectionURI: String
    let items: [ComicSummary]
    let returned: Int
    
    enum CodingKeys: String, CodingKey {
        case available, collectionURI, items, returned
    }
}


struct ComicSummary: Codable, Hashable {
    let resourceURI: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }
}


struct SeriesList: Codable, Hashable {
    let available: Int
    let collectionURI: String
    let items: [SeriesSummary]
    let returned: Int
    
    enum CodingKeys: String, CodingKey {
        case available, collectionURI, items, returned
    }
}


struct SeriesSummary: Codable, Hashable {
    let resourceURI: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }
}


struct StoryList: Codable, Hashable {
    let available: Int
    let collectionURI: String
    let items: [StorySummary]
    let returned: Int
    
    enum CodingKeys: String, CodingKey {
        case available, collectionURI, items, returned
    }
}


struct StorySummary: Codable, Hashable {
    let resourceURI: String
    let name: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case resourceURI, name, type
    }
}
