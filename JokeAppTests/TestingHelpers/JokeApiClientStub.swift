//
//  JokeApiClientStub.swift
//  JokeAppTests
//
//  Created by Yan Dias on 28/06/21.
//

import Foundation
import Combine
@testable import JokeApp


class JokeApiClientStub: JokeRepository {
    
    var result: Result<JokeEntity, NetworkError>?
    
    init(result: Result<JokeEntity, NetworkError>? = nil) {
        self.result = result
    }
    
    func getJoke() -> AnyPublisher<JokeEntity, NetworkError> {
        guard let result = result else {
            fatalError("JokeApiClient should not be called")
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}
