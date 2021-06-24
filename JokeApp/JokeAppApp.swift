//
//  JokeAppApp.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct JokeAppApp: App {
    let client = JokeApiClient().getJoke().sink { completion in
        print(completion)
    } receiveValue: { joke in
        print(joke)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(
                initialState: JokeState(
                    currentJoke: Joke(id: "00001",
                                      setup: "setup",
                                      punchline: "punchline"),
                    favoriteJokes: [:
                    ]
                ),
                reducer: appReducer.debug(),
                environment: JokeEnviroment(
                    jokeApiClient: JokeApiClient()
                )
            ))
        }
    }
}
