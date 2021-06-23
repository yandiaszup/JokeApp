//
//  NetworkClient.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import Foundation
import Combine

struct Response: Decodable {
    let body: [JokeEntity]
}

struct JokeEntity: Decodable, Equatable {
    let setup: String
    let punchline: String
}

enum NetworkError: Error, Equatable {
    case networkError
    case apiError
}

protocol JokeRepository {
    func getJoke() -> AnyPublisher<JokeEntity, NetworkError>
}

struct JokeApiClient: JokeRepository {
    
    var session: URLSession = URLSession.shared
    
    func getJoke() -> AnyPublisher<JokeEntity, NetworkError> {
        session.dataTaskPublisher(for: buildUrlRequest())
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .tryMap({ response in
                if let joke = response.body.first {
                    return joke
                } else {
                    throw NetworkError.apiError
                }
            })
            .mapError { error in NetworkError.networkError }
            .eraseToAnyPublisher()
    }
    
    private func buildUrlRequest() -> URLRequest {
        let url = URL(string: "https://dad-jokes.p.rapidapi.com/random/joke")!
        let headers: [String: String] = [
            "x-rapidapi-key": "892abfcd3cmsh3cca36ae3e40cb0p186360jsn7a6b411975ce",
            "x-rapidapi-host": "dad-jokes.p.rapidapi.com",
            "useQueryString": "true"
        ]
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { field, value in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        return urlRequest
    }
}
