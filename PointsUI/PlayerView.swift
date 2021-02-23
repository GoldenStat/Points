//
//  PlayerUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

enum PlayerViewTitleStyle {
    case normal, inline
}

struct PlayerView: View {
    
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player
    
    var titleStyle : PlayerViewTitleStyle = .inline

    private var currentRule : Rule { settings.rule }
    private var playerUI: PlayerUIType { currentRule.playerUI }
        
    var body: some View {
            VStack() {
                
                if titleStyle == .normal {
                    PlayerHeadline(player: player)
                        .padding(.horizontal)
                }
                
                VStack() {
                    
                    if titleStyle == .inline {
                        PlayerHeadline(player: player)
                            .padding(.horizontal)
                            .zIndex(1)
                    }
                    
                    ScoreRepresentationView(
                        score: player.score,
                        uiType: playerUI
                    )
                    .animation(.default)
                    .gesture(countScoreGesture)
                }
                .emphasizeShape(cornerRadius: cornerRadius)
                .padding()
            }
    }
    
    /// updates the player's score
    private var countScoreGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 2.0)) {
                    // add score for this player
                    player.add(score: settings.scoreStep)
                    // modify current history buffer
                    settings.storeInHistory()
                }
                settings.startTimer()
            }
    }

    // MARK: private variables
    private let cornerRadius : CGFloat = 12.0
    private let scoreBoardRatio: CGFloat = 3/4
    
}

// MARK: - subviews

/// "title" of the playerView - the name with stats (e.g. games won)
/// sets the editing player in game settings
struct PlayerHeadline: View {
    
    @EnvironmentObject var settings: GameSettings
    @ObservedObject var player : Player

    /// marks a player as 'active' (e.g. he's the dealer)
    private var isActive: Bool { settings.activePlayer == player }
    
    /// the name is being edited - accessible from parent
    private var isEditing: Bool { settings.editingPlayer == player }
    
    var body: some View {
        VStack(spacing: 0) {
            Group{
                if (isEditing) {
                    TextField(player.name, text: $player.name)
                        .padding(3)
                        .background(Color.white.opacity(0.5)
                                        .cornerRadius(12)
                        )
                        .disableAutocorrection(true)
                        .keyboardType(.alphabet)
                        .scaleEffect(1.1)
                } else {
                    Text(player.name)
                }
            }
            .font(.largeTitle)
            .fixedSize()
            
            CounterView(counter: player.games)
        }
        .onTapGesture(count: 2) {
            withAnimation() {
                settings.editingPlayer = player
            }
        }
    }
}

/// the counter for the games a player has won
struct CounterView: View {

    let counter: Int

    var counterImage: some View {
        Image(systemName: "circle.fill")
            .font(.caption)
            .foregroundColor(.pointbuffer)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            ForEach(0..<counter, id: \.self) { num in
                counterImage
            }
        }
    }
}


// MARK: - some functions imported from John for Keyboard hiding and device rotation

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


// MARK: - preview

struct PlayerUI_Previews: PreviewProvider {
    static var player = Player(from: Player.Data(name: "Alexander", score: Score(21), games: 3))
    static var settings = GameSettings()
    
    static var previews: some View {
        VStack {
            PlayerView(player: player)
            PlayerView(player: player)
        }
        .aspectRatio(0.3, contentMode: .fit)
        .environmentObject(settings)
    }
}
