//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by Mohammad Haris Sofi on 27/02/24.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkingError : LocalizedError {
        case badUrlResponse(url : URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url ) : return "[404] bad url response : \(url)"
            case .unknown : return "[202] unknown error"
            }
        }
    }
    
    static func download (url : URL) -> AnyPublisher<Data, any Error>{
      return URLSession.shared.dataTaskPublisher(for: url)
           // .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( { try handleUrlResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    static func handleUrlResponse (output : URLSession.DataTaskPublisher.Output , url : URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse ,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        return output.data
    }
    static func handleCompletion (completion : Subscribers.Completion<Error> ) {
        switch completion {
        case .finished :
            break
        
        case .failure(let error) :
            print(error.localizedDescription)
        }
    }
}
