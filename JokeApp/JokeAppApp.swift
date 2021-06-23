//
//  JokeAppApp.swift
//  JokeApp
//
//  Created by Yan Dias on 23/06/21.
//

import SwiftUI

@main
struct JokeAppApp: App {
    let client = JokeApiClient().getJoke().sink { completion in
        print(completion)
    } receiveValue: { joke in
        print(joke)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
