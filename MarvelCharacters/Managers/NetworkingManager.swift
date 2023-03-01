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
    
    let baseURL = Setup.baseURL
    
    
    func fetchCharacters(offset: Int = 0, completion: @escaping (Result<[MarvelCharacter], Error>) -> Void) {
        let hash = MD5(string: "\(ts)\(apiKeyPrivate)\(apiKeyPublic)")
        let url = "\(baseURL)limit=\(30)&offset=\(offset)&ts=\(ts)&apikey=\(apiKeyPublic)&hash=\(hash)"
        
        AF.request(url).responseDecodable(of: APIResponse.self) { response in
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
        let url = "\(secureURL).\(ext)?ts=\(ts)&apikey=\(apiKeyPublic)&hash=\(hash)"
        
        AF.request(url).responseData { response in
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
