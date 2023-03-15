//
//  NetworkingManager.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 24/02/2023.
//

import Foundation
import Alamofire
import CryptoKit

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {
        self.apiKeyPublic = InfoPlistParser.getStringValue(forKey: Setup.kAPIPublicKey)
        self.apiKeyPrivate = InfoPlistParser.getStringValue(forKey: Setup.kAPIPrivateKey)
    }
    
    let apiKeyPublic: String
    let apiKeyPrivate: String
    let ts = String(Date().timeIntervalSince1970)
    
    let charactersBaseURL = Setup.baseURL
    
    
    func fetchItems<T: Decodable>(type: T.Type, baseURL: String, offset: Int = 0, completion: @escaping (Result<T, Error>) -> Void) {
        let hash = MD5(string: "\(ts)\(apiKeyPrivate)\(apiKeyPublic)")
        
        let parameters = ["limit": String(30),
                          "offset": String(offset),
                          "ts": ts,
                          "apikey": apiKeyPublic,
                          "hash": hash]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let results):
                completion(.success(results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    func fetchCharactersWith(query: String, completion: @escaping (Result<[MarvelCharacter], Error>) -> Void) {
        let hash = MD5(string: "\(ts)\(apiKeyPrivate)\(apiKeyPublic)")
        
        let parameters = ["nameStartsWith": query,
                          "ts": ts,
                          "apikey": apiKeyPublic,
                          "hash": hash]
        
        AF.request(charactersBaseURL, parameters: parameters).responseDecodable(of: CharactersDataResponse.self) { response in
            switch response.result {
            case .success(let results):
                completion(.success(results.data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchImage(baseURL: String, ext: String, completion: @escaping (Result<UIImage, MCError>) -> Void) {
        guard baseURL != ImageNotAvailable.url else {
            if let image = MCImages.imageNotFoundPlaceholder {
                completion(.success(image))
                return
            } else {
                return
            }
        }
        
        let hash = MD5(string: "\(ts)\(apiKeyPrivate)\(apiKeyPublic)")
        
        var secureURL = baseURL
        secureURL.insert("s", at: secureURL.index(secureURL.startIndex, offsetBy: 4))
        secureURL.append(".\(ext)")
        
        let parameters = ["ts": ts,
                          "apikey": apiKeyPublic,
                          "hash": hash]
        
        AF.request(secureURL, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    completion(.success(image))
                } else {
                    completion(.failure(MCError.failedToDecodeImageFromData))
                }
            case .failure(let error):
                completion(.failure(MCError.alamofireResponseError(message: error.localizedDescription)))
            }
        }
    }
    
    
    // MARK: - Hash method
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
