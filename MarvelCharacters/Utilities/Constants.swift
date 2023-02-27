//
//  Constants.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 23/02/2023.
//

import UIKit

enum Setup {
    static let kAPIPrivateKey = "APIPrivateKey"
    static let kAPIPublicKey = "APIPublicKey"
    
    static let baseURL = "https://gateway.marvel.com/v1/public/characters?"
}


enum MCColors {
    static let marvelRed = UIColor(named: "MarvelRed")!
    static let marvelDarkRed = UIColor(named: "MarvelDarkRed")!
    static let marvelGoldenrod = UIColor(named: "MarvelGoldenrod")!
}


enum MCImages {
    static let imageNotFoundPlaceholder = UIImage(named: "imageNotFound")
}


enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}


enum ImageNotAvailable {
    static let url = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
}
