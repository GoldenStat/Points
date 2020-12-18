//
//  PointsUI.swift
//  PointsUI
//
//  Created by Alexander Völz on 06.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

// MARK: main entry point
import SwiftUI

@main
struct PointsUIApp: App {
    static let name = "Points UI"
    
    var body: some Scene {
        WindowGroup {
            ContentView(gameStarted: false)
        }
    }
}

#if os(macOS)
extension View {
    func navigationBarTitle(_ title: String) -> some View {
        self
    }
}
#endif

#if os(watchOS)
struct NavigationView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
    }
}
#endif

