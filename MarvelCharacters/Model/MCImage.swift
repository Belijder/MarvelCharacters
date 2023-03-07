//
//  MCImage.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 03/03/2023.
//

import Foundation

struct MCImage: Codable, Hashable {
    let path: String
    let `extension`: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }
}
