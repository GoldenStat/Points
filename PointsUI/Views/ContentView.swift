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
    @State var navigationBarIsHidden = true
    @State private var settingsEditorIsShown = false
    @State private var needsUpdate = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightMidnight
                    .edgesIgnoringSafeArea(.all)
                
                GameBoardView()
            }
            .environmentObject(settings)
            .navigationBarTitle(GameSettings.name)
            .navigationBarHidden(true)
            .navigationBarItems(leading: HStack {
                Button() {
                    settings.history.undo()
                    settings.updatePlayersWithCurrentState()
                    needsUpdate.toggle()
                    
                } label: {
                    Image(systemName: "arrow.uturn.left")
                        .padding()
                }
//                .disabled(!settings.history.canUndo)
                Button() {
                    settings.history.redo()
                    settings.updatePlayersWithCurrentState()
                    needsUpdate.toggle()
                } label: {
                    Image(systemName: "arrow.uturn.right")
                        .padding()
                }
//                .disabled(!settings.history.canRedo)
            })
            .onTapGesture(count: 2) {
                navigationBarIsHidden.toggle()
            }
            .sheet(isPresented: $settingsEditorIsShown) {
                SettingsEditor()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
