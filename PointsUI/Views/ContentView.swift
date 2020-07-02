//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var settings : GameSettings = GameSettings()
    @State var showMenuBar = false
    
    var body: some View {
        
        ZStack {
            Color.darkNoon
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if showMenuBar {
                    MenuBar()
                        .transition(.move(edge: .top))
                }
                GameBoardView()
                    .background(Color.darkNoon)
            }
            .onTapGesture(count: 2) {
                showMenuBar.toggle()
            }
        }
        .animation(.default)
        .environmentObject(settings)
    }
}

struct MenuBar: View {
    var body: some View {
        HStack {
            HistoryButtons()
            SettingsButton()
        }
    }
}

struct HistoryButtons: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        HStack {
            Button() { settings.undo() }
                label: {
                    Image(systemName: "arrow.uturn.left")
                        .padding()
                }
            Button() { settings.redo() }
                label: {
                    Image(systemName: "arrow.uturn.right")
                        .padding()
                }
        }
    }
}

struct SettingsButton: View {
    @EnvironmentObject var settings: GameSettings
    
    @State var isShown: Bool = false
    
    var body: some View {
        Button() {
            isShown.toggle()
        } label: {
            isShown ? Image(systemName: "text.badge.checkmark") : Image(systemName: "gear")
        }
        .popover(isPresented: $isShown) {
            EditView()
                .onDisappear() {
                    settings.updateSettings()
                }
                .environmentObject(settings)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: GameSettings())
    }
}
