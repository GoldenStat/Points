//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var settings = GameSettings()
    
    // MARK: Change Appearance
    @State private var settingsEditorIsShown = false
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.lightMidnight
                    .edgesIgnoringSafeArea(.all)
                            
                GameBoardView()
                    .animation(.default)
            }
            .environmentObject(settings)
            .navigationBarTitle(Text(GameSettings.name))
            .navigationBarItems(
                leading: HStack {
                    Button() {
                        settings.history.undo()
                        settings.updatePlayersWithCurrentState()
                        
                    } label: {
                        Image(systemName: "arrow.uturn.left")
                            .padding()
                    }
                    Button() {
                        settings.history.redo()
                        settings.updatePlayersWithCurrentState()
                    } label: {
                        Image(systemName: "arrow.uturn.right")
                            .padding()
                    }
                },
                trailing: HStack {
                    Button() {
                        settingsEditorIsShown.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                })
            .sheet(isPresented: $settingsEditorIsShown) {
                SettingsEditor()
                    .environmentObject(settings)
                    .onDisappear {
                        settings.updateSettings()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}