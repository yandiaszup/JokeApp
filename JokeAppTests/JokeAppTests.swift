//
//  JokeAppTests.swift
//  JokeAppTests
//
//  Created by Yan Dias on 25/06/21.
//

import XCTest
import ComposableArchitecture
import Combine
@testable import JokeApp

class JokeAppTests: XCTestCase {

    func testFavoriteJoke() {
        let jokeId = "00001"
        var joke = Joke(id: jokeId, setup: "setup", punchline: "punchline", isFavorite: false)
        let store = TestStore(
            initialState: JokeState(currentJoke: joke, favoriteJokes: [:]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub())
        )
        
        store.assert(
            .send(.favoriteJokeTapped) {
                $0.currentJoke.isFavorite = true
                joke.isFavorite = true
                $0.favoriteJokes = [jokeId: joke]
            }
        )
    }
    
    func testUnFavoriteJoke() {
        let jokeId = "00001"
        let joke = Joke(id: jokeId, setup: "setup", punchline: "punchline", isFavorite: true)
        let store = TestStore(
            initialState: JokeState(currentJoke: joke, favoriteJokes: [jokeId: joke]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub())
        )
        
        store.assert(
            .send(.unFavoriteJokeTapped(id: jokeId)) {
                $0.currentJoke.isFavorite = false
                $0.favoriteJokes = [:]
            }
        )
    }
    
    func testRandomJokeSuccess() {
        let jokeId = "00001"
        let jokeEntity = JokeEntity(_id: jokeId, setup: "setup", punchline: "punchline")
        let joke = Joke(entity: jokeEntity)
        
        let store = TestStore(
            initialState: JokeState(currentJoke: joke, favoriteJokes: [:]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub(result: .success(jokeEntity)))
        )
        
        store.assert(
            .send(.randomJokeTapped),
            .receive(.randomJokeResponse(.success(jokeEntity))) {
                $0.currentJoke = joke
            }
        )
    }
    
    func testRandomJokeFailure() {
        let jokeId = "00001"
        let joke = Joke(id: jokeId, setup: "setup", punchline: "punchline", isFavorite: false)
        
        let store = TestStore(
            initialState: JokeState(currentJoke: joke, favoriteJokes: [:]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub(result: .failure(.networkError)))
        )
        
        store.assert(
            .send(.randomJokeTapped),
            .receive(.randomJokeResponse(.failure(.networkError))) {
                $0.isShowingAlert = true
            }
        )
    }
    
    func testRandomJokeWhenIsAlreadyFavorite() {
        let jokeId = "0002"
        let jokeEntity = JokeEntity(_id: jokeId, setup: "newSetup", punchline: "newPunchline")
        let newJoke = Joke(entity: jokeEntity, isFavorite: true)
        let currentJoke = Joke(id: "0001", setup: "setup", punchline: "punchline", isFavorite: false)
        
        let store = TestStore(
            initialState: JokeState(currentJoke: currentJoke, favoriteJokes: [jokeId: newJoke]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub(result: .success(jokeEntity)))
        )
        
        store.assert(
            .send(.randomJokeTapped),
            .receive(.randomJokeResponse(.success(jokeEntity))) {
                $0.currentJoke = newJoke
            }
        )
    }

    func testDismissedAlert() {
        let currentJoke = Joke(id: "0001", setup: "setup", punchline: "punchline", isFavorite: false)
        
        let store = TestStore(
            initialState: JokeState(currentJoke: currentJoke, favoriteJokes: [:]),
            reducer: appReducer,
            environment: JokeEnviroment(jokeApiClient: JokeApiClientStub())
        )
        
        store.assert(
            .send(.dismissedAlert) {
                $0.isShowingAlert = false
            }
        )
    }
}
