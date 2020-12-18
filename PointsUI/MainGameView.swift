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
    
    @State private var showHistory: Bool = false
    
    /// these views are all on top of another
    var body: some View {
        ZStack {
    
            // MARK: Board
            BoardUI()
                .blur(radius: blurRadius)
                .padding(.horizontal)
                .drawingGroup()
                .animation(.easeIn)
                .gesture(showHistoryGesture)
                .environmentObject(settings)
          
            // MARK: History View
            if showHistory {
                GeometryReader { geo in
                    historyView(sized: geo.size)
                }
            }
            
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
            
    // MARK: - History View

    private  var showHistoryGesture : some Gesture { LongPressGesture(minimumDuration: 1.0, maximumDistance: 50)
        .onEnded() {_ in
            withAnimation() {
                showHistory = true                
            }
        }
    }
    
    private var blurRadius : CGFloat { blurBackground ? 4.0 : 0.0 }
    private  var blurBackground: Bool { showHistory }
    
    func historyView(sized geometrySize: CGSize) -> some View {
        let heightFactor: CGFloat = 0.6
        let height = geometrySize.height * heightFactor
        
        // NOTE: use @ScaledMetric for height? Use maxHeight, instead?
        return ScoreHistoryView()
            .frame(height: height)
            .emphasizeShape(cornerRadius: 16.0)
            .environmentObject(settings)
            .onTapGesture() {
                withAnimation() {
                    showHistory = false
                }
            }
            .transition(.opacity)
            .padding()
            .padding(.top)
    }
}

// MARK: - previews

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            MainGameView()
        }
        .environmentObject(GameSettings())
    }
}

