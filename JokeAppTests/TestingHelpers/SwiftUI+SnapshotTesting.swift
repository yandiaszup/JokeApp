//
//  SwiftUI+SnapshotTesting.swift
//  JokeAppTests
//
//  Created by Yan Dias on 28/06/21.
//

import SnapshotTesting
import SwiftUI

extension View {
    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        
        return vc
    }
}
