//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let invisible = Color.white.opacity(0.01)
}

/// the game board with modifiers for history overlay
struct MainGameView: View {
    
    @EnvironmentObject var settings : GameSettings
        
    /// these views are all on top of another
    var body: some View {
        ZStack {
    
            // MARK: Board
            BoardUI()
                .padding(.horizontal)
                .environmentObject(settings)
            
            // MARK: Won Round
            if settings.playerWonRound != nil {
                PlayerWonRound()
            }
            
            // MARK: Won Game
            if settings.playerWonGame != nil {
                PlayerWonGame()
            }
            
        }
    }
}

// MARK: - previews

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            MainGameView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(GameSettings())
    }
}

