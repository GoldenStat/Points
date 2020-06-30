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
    @State private var settingsAreShown = false
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationView {

            VStack {
                
                if settingsAreShown {
                    EditView()
                }
                
                ZStack {
                    Color.lightMidnight
                        .edgesIgnoringSafeArea(.all)
                    
                    GameBoardView()
                }
                .animation(.default)
            }
            .environmentObject(settings)
            .navigationBarItems(
                leading: HistoryButtons(),
                trailing: HStack {
                    Button() {
                        settingsAreShown.toggle()
                    } label: {
                        settingsAreShown ? Image(systemName: "text.badge.checkmark") : Image(systemName: "gear")
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
