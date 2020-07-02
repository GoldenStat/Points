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
    var settingsEditorIsShown = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                ZStack {
                    Color.lightMidnight
                        .edgesIgnoringSafeArea(.all)
                    
                    GameBoardView()
                }
                .animation(.default)
            }
            .navigationBarItems(leading: HistoryButtons())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SettingsButton()
                }
            }
        }
        .environmentObject(settings)

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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: GameSettings())
    }
}
