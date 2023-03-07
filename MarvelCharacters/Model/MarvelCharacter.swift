//
//  MarvelCharacter.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 24/02/2023.
//

import Foundation

struct CharactersDataResponse: Decodable {
    let data: CharacterData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CharacterData: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count, results
    }
}

struct MarvelCharacter: Decodable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: MCImage
    let comics: ComicList
    let series: SeriesList
    let stories: StoryList
    let events: EventList
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, comics, series, stories, events
    }
}

struct ComicList: Decodable, Hashable {
    let collectionURI: String
}

struct ComicSummary: Decodable, Hashable {
    let resourceURI: String
    let name: String
}

struct SeriesList: Decodable, Hashable {
    let collectionURI: String
    let items: [SeriesSummary]
    
    enum CodingKeys: String, CodingKey {
        case collectionURI, items
    }
}

struct SeriesSummary: Decodable, Hashable {
    let resourceURI: String
    let name: String
}

struct StoryList: Decodable, Hashable {
    let collectionURI: String
}

struct EventList: Decodable, Hashable {
    let collectionURI: String
}
