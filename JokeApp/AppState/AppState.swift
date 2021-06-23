//
//  AppState.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import Foundation
import ComposableArchitecture

struct Joke: Equatable, Identifiable {
    let id: UUID
    let setup: String
    let punchline: String
}

struct JokeState: Equatable {
    var currentJoke: Joke
    var favoriteJokes: [Joke]
}

struct JokeEnviroment {
    var jokeApiClient: JokeApiClient
    var uuidProvider: () -> UUID
}

enum JokeAction: Equatable {
    case randomJokeTapped
    case favoriteJokeTapped
    case randomJokeResponse(Result<JokeEntity, NetworkError>)
}

let appReducer = Reducer<JokeState, JokeAction, JokeEnviroment> { state, action, enviroment in
    switch action {
    case .favoriteJokeTapped:
        if state.favoriteJokes.last == state.currentJoke {
            state.favoriteJokes.removeLast()
        } else {
            state.favoriteJokes.append(state.currentJoke)
        }
        
        return .none
        
    case .randomJokeTapped:
        return enviroment.jokeApiClient
            .getJoke()
            .eraseToEffect()
            .catchToEffect()
            .map(JokeAction.randomJokeResponse)
        
    case .randomJokeResponse(.success(let entity)):
        state.currentJoke = .init(id: enviroment.uuidProvider(), setup: entity.setup, punchline: entity.punchline)
        return .none
        
    case .randomJokeResponse(.failure):
        return .none
    }
}
