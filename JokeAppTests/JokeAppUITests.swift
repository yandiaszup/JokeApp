//
//  JokaAppSnapshotTests.swift
//  JokeAppTests
//
//  Created by Yan Dias on 28/06/21.
//

import XCTest
import SnapshotTesting
@testable import ComposableArchitecture
@testable import JokeApp

class JokeAppUITests: XCTestCase {
    
    let initialState = JokeState(
        currentJoke: .init(
            id: "0",
            setup: "What do you give a sick lemon?",
            punchline: "Lemonaid.",
            isFavorite: false
        ),
        favoriteJokes: ["1":.init(id: "1", setup: "What do you call corn that joins the army?", punchline: "Kernel.", isFavorite: true)]
    )
    
    let enviroment = JokeEnviroment(
        jokeApiClient: JokeApiClientStub(
            result: .success(JokeEntity(_id: "00002", setup: "Bad at golf?", punchline: "Join the club."))
        )
    )
    
    func testRandomJoke() {
        let store = Store(
            initialState: initialState,
            reducer: appReducer,
            environment: enviroment
        )
        let view = ContentView(store: store)
        let vc = view.toVC()
        
        assertSnapshot(matching: vc, as: .image)
        store.send(.randomJokeTapped)
        assertSnapshot(matching: vc, as: .image)
    }
    
    func testFavoriteJoke() {
        let store = Store(
            initialState: initialState,
            reducer: appReducer,
            environment: enviroment
        )
        let view = ContentView(store: store)
        let vc = view.toVC()
        
        assertSnapshot(matching: vc, as: .image)
        store.send(.favoriteJokeTapped)
        assertSnapshot(matching: vc, as: .image)
        store.send(.favoriteJokeTapped)
        assertSnapshot(matching: vc, as: .image)
    }
    
    func testUnfavoriteJoke() {
        let store = Store(
            initialState: initialState,
            reducer: appReducer,
            environment: enviroment
        )
        let view = FavoritesView(store: store)
        let vc = view.toVC()
        
        assertSnapshot(matching: vc, as: .image)
        store.send(.unFavoriteJokeTapped(id: "1"))
        assertSnapshot(matching: vc, as: .image)
    }
}

