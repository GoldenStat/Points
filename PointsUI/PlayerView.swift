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
            
            playerName(titleStyle == .normal)
                .padding(.horizontal)
            
            VStack() {
                Spacer()
                    .frame(height: 40)
                
                ScoreRepresentationView(
                    score: player.score,
                    uiType: playerUI
                )
                .gesture(countScoreGesture)
            }
            .emphasizeShape(cornerRadius: cornerRadius)
            .padding()
            .overlay(playerName(titleStyle == .inline))
        }
    }
    
    @ViewBuilder func playerName(_ isVisible: Bool) -> some View {
        if isVisible {
            VStack {
                PlayerHeadline(player: player)
                    .padding(.horizontal)
                    .zIndex(1)
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
    
    /// updates the player's score
    private var countScoreGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                // add score for this player
                player.add(score: settings.scoreStep)
                // modify current history buffer
                settings.storeInHistory()
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
    @State private var ignore = false
    
    var body: some View {
        VStack(spacing: 0) {
            Group{
                if (isEditing) {
                    TextField(player.name, text: $player.name, onCommit: {
                        settings.editingPlayer = nil
                    })
                    .padding(.top)
                } else {
                    Text(player.name)
                        .fontWeight(.bold)
                        .playerHeadlineStyle()
                    
                }
            }
            .textFieldStyle(PlayerNameTextField())

            CounterView(counter: player.games)
                .padding(.horizontal)
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
            .foregroundColor(.pointbuffer.opacity(0.8))
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Spacer()
            ForEach(0..<counter, id: \.self) { num in
                counterImage
            }
        }
    }
}


// MARK: - text view modifiers
// taken from https://thehappyprogrammer.com/custom-textfield-in-swiftui/

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}

struct PlayerNameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fixedSize()
            .padding()
    }
}

struct NeumorphicModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .background(Color.white.opacity(0.2))
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
    }
}

extension View {
    func neumorphic() -> some View {
        self
            .modifier(NeumorphicModifier())
    }
    func playerHeadlineStyle() -> some View {
        self
            .modifier(PlayerNameModifier())
    }
}

struct PlayerNameTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .autocapitalization(.words)
            .disableAutocorrection(true)
            .keyboardType(.alphabet)
            .font(.largeTitle)
            .fixedSize()
            .neumorphic()
            .frame(width: .infinity)
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



struct PlayerUI_Previews: PreviewProvider {
    static var previews: some View {
        BoardUI()
            .environmentObject(GameSettings())
    }
}
