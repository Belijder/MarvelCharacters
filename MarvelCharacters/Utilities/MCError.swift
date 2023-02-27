//
//  MCError.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 26/02/2023.
//

import Foundation

enum MCError: Error {
    case failedToDecodeImageFromData
    case alamofireResponseError(message: String)
}
