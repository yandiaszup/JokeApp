//
//  FavoritesView.swift
//  JokeApp
//
//  Created by Yan Dias on 24/06/21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {
    let store: Store<JokeState, JokeAction>
    
    var body: some View {
        List {
            WithViewStore(store) { viewStore in
                ForEach(Array(viewStore.state.favoriteJokes.values)) { joke in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(joke.setup)
                            Text(joke.punchline)
                        }
                        Spacer()
                    }
                    .purbleBox()
                }
            }
        }.navigationTitle("Favorite Jokes")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(store: Store(
            initialState: JokeState(
                currentJoke: Joke(id: "00001",
                                  setup: "setup",
                                  punchline: "punchline"),
                favoriteJokes: [
                    "00001" : Joke(id: "00001",
                         setup: "setup",
                         punchline: "punchline"),
                    "00002" : Joke(id: "00002",
                         setup: "setup1",
                         punchline: "punchline1")
                ]
            ),
            reducer: appReducer.debug(),
            environment: JokeEnviroment(
                jokeApiClient: JokeApiClient()
            )
        ))
    }
}
