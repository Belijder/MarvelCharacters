//
//  CreatorList.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 03/03/2023.
//

import Foundation

struct CreatorList: Hashable, Decodable {
    let available: Int
    let returned: Int
    let collectionURI: String
    let items: [CreatorSummary]
}

struct CreatorSummary: Hashable, Decodable {
    let resourceURI: String
    let name: String
    let role: String
}
