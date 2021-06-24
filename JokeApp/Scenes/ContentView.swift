//
//  ContentView.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<JokeState, JokeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    JokeCard(store: store)
                    Button("get random joke") {
                        viewStore.send(.randomJokeTapped)
                    }
                    .purbleBox()
                    .padding()
                }
                .navigationTitle("Uncle Jokes")
                .navigationBarItems(trailing: NavigationLink(destination: FavoritesView(store: store)) {
                    Text("Favorites")
                })
            }
        }
    }
}

struct JokeCard: View {
    let store: Store<JokeState, JokeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack(alignment: .leading) {
                    Text(viewStore.state.currentJoke.setup)
                        .padding()
                    Text(viewStore.state.currentJoke.punchline)
                        .padding()
                }
                Spacer()
                Button(action: { viewStore.send(.favoriteJokeTapped) }) {
                    Image(systemName: viewStore.state.currentJoke.isFavorite ? "star.fill" : "star")
                }
                .padding()
            }
            .purbleBox()
            .padding()
        }
    }
}

extension View {
    func purbleBox() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(
            initialState: JokeState(
                currentJoke: Joke(id: "00001",
                                  setup: "setup",
                                  punchline: "punchline"),
                favoriteJokes: [:]
            ),
            reducer: appReducer.debug(),
            environment: JokeEnviroment(
                jokeApiClient: JokeApiClient()
            )
        ))
    }
}
