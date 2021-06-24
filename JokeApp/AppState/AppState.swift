//
//  AppState.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import Foundation
import ComposableArchitecture

struct Joke: Equatable, Identifiable {
    let id: String
    let setup: String
    let punchline: String
    var isFavorite: Bool = false
}

struct JokeState: Equatable {
    var isShowingAlert: Bool = false
    var currentJoke: Joke
    var favoriteJokes: [String: Joke]
}

struct JokeEnviroment {
    var jokeApiClient: JokeRepository
}

enum JokeAction: Equatable {
    case dismissedAlert
    case randomJokeTapped
    case favoriteJokeTapped
    case randomJokeResponse(Result<JokeEntity, NetworkError>)
}

let appReducer = Reducer<JokeState, JokeAction, JokeEnviroment> { state, action, enviroment in
    switch action {
    case .favoriteJokeTapped:
        if state.currentJoke.isFavorite {
            state.currentJoke.isFavorite = false
            state.favoriteJokes[state.currentJoke.id] = nil
        } else {
            state.currentJoke.isFavorite = true
            state.favoriteJokes[state.currentJoke.id] = state.currentJoke
        }
        return .none
        
    case .randomJokeTapped:
        return enviroment.jokeApiClient
            .getJoke()
            .eraseToEffect()
            .catchToEffect()
            .map(JokeAction.randomJokeResponse)
        
    case .randomJokeResponse(.success(let entity)):
        if let joke = state.favoriteJokes[entity._id] {
            state.currentJoke = joke
        } else {
            state.currentJoke = .init(id: entity._id, setup: entity.setup, punchline: entity.punchline)
        }
        return .none
        
    case .randomJokeResponse(.failure):
        state.isShowingAlert = true
        return .none
        
    case .dismissedAlert:
        state.isShowingAlert = false
        return .none
    }
}
