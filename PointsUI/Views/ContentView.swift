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
    
    @State private var settingsEditorIsShown = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                ZStack {
                    Color.lightMidnight
                        .edgesIgnoringSafeArea(.all)
                    
                    GameBoardView()
                        .environmentObject(settings)
                }
                .animation(.default)
            }
            .navigationBarItems(leading: HistoryButtons())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SettingsButton()
                        .environmentObject(settings)
                }
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
        ContentView()
    }
}
