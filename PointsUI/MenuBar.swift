//
//  BottomMenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 18.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// show a menu bar for game flow control functionality
///
/// this View is displayed by a Main View and get's its bindings from there
/// each Button sets a different variable that is used in the main display logic
/// 1. provides a way to get into settings
/// 1. quickchange rules
/// 1. display information
/// 1. feedback for history modification
/// 1. get overview (e.g. History)
///
/// *expects* GameSettings environment variable
struct MenuBar : View {
    @EnvironmentObject var settings: GameSettings

        /// Settings display control
    @Binding var showSettings: Bool
    
        /// info display control
    @Binding var showInfo: Bool

        /// History control (with step counter for preview)
    @Binding var showHistory: Bool
    
    /// Connect the token
    var token: Token { settings.players.token }
    
    @Binding var tokenState: TokenState

    var steps: Int = 0
        
    var body : some View {
        HStack {
            
            HistoryMenuSymbol(show: $showHistory, counter: steps)
                .fontSized()
            
            Button() {
                withAnimation() {
                    tokenState.toggle()
                    token.state = tokenState
                }
            } label: {
                MenuTokenView(size: 32, state: tokenState)
            }            
            
            Spacer()
            
            ScoreRulePicker()
                .padding(.horizontal, 20)
            
            InfoMenuSymbol(show: $showInfo)
                .fontSized()
        }
        .frame(width: 400, height: 80)
        .overlay(SettingsButton(show: $showSettings))
        .padding(.horizontal)
        
    }
}

// MARK: - subviews

struct MenuTokenView: View {
    var size: CGFloat
    var state: TokenState
    @Namespace var tokenMenuSpace
    
    // .active -> .free -> .inactive (see Token().toggle())
    var opacity: Double { state == .free ? 0.5 : 1.0 }
    var shadowColor: Color { state == .active ? .black : .clear }
    
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .overlay(
                Text ("T")
                    .font(.title)
                    .foregroundColor(.white)
            )
//            .matchedGeometryEffect(id: "TokenMenu", in: tokenMenuSpace)
            .opacity(opacity)
            .shadow(color: shadowColor, radius: 8, x: 2, y: 2)
    }
    
}
/// shows the scoresteps if they are configurable, just the values, if not
struct ScoreRulePicker: View {
    @EnvironmentObject var settings: GameSettings

    var body: some View {
        switch settings.rule.scoreStep {
        case .namedMultiple(let dict):
            // we get a dictionary, so we want a context-menu with all the values
            ScorePicker(sections: dict)
        case .some(_):
            ScalingTextView("\(settings.scoreStep)", scale: 0.5)
                .frame(width: 60, height: 40)
        default:
            EmptyView()
        }
    }
}

/// show the symbol in the left part of the menu
/// history control: show
fileprivate struct HistoryMenuSymbol: View {
    @Binding var show: Bool
    var counter: Int = 0
    
    var body: some View {
        ZStack {
            Button(action: { show.toggle() },
                   label: {
                Image(systemName: "doc.plaintext")
            })
            if counter != 0 {
                Text(abs(counter).description)
                    .opacity(0.4)
                    .scaleEffect(2.8)
            }
        }
    }
}

/// show the symbol in the right part of the menu
/// info button, if no timer is running, one of two timerviews, otherwise
/// - *expects*: GameSettings environment variable
fileprivate struct InfoMenuSymbol: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var show: Bool
    
    // the circle views look better a little smaller
    private let circleScaleRatio : CGFloat = 0.4
    private var showCircleView: Bool { settings.timerPointsStarted }
    private var showCountDownView: Bool { settings.timerRoundStarted }
    private var countdown: TimeInterval { settings.timeIntervalToCountRound }
    
    var body: some View {
        if showCircleView {
            ActiveCircleView()
                .blur(radius: 3.0)
                .scaleEffect(circleScaleRatio)
        } else if showCountDownView {
            CountdownView(totalTimeInterval: countdown)
                .blur(radius: 3.0)
                .opacity(0.8)
                .scaleEffect(circleScaleRatio)
        } else {
            Button() {
                show.toggle()
            } label: {
                Image(systemName:
                        "info")
            }
        }
    }
}

/// scale a view according to a given font
extension View {
    func fontSized(_ font: Font = .largeTitle) -> some View {
            Image(systemName: "circle")
                .font(font)
                .opacity(0.01)
                .background(self)
    }
}

// MARK: - sample View
/// sample view only for showing what menu would look like, starts / stops timer
fileprivate struct MenuBarSampleView: View {
    @EnvironmentObject var settings : GameSettings
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showHistory = false
    @State private var padding : CGFloat = 10
    @State var tokenState : TokenState = .inactive
    
    var body: some View {
        VStack {
            MenuBar(showSettings: $showSettings,
                    showInfo: $showInfo,
                    showHistory: $showHistory,
                    tokenState: $tokenState
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
            
            VStack {
                Section(header: Text("Token")) {
                    switch tokenState {
                    case .inactive:
                        Text("inactive")
                        
                    case .active:
                        Text("active")
                        
                    case .free:
                        Text("free")
                    }
                }
                Section(header: Text("Timer")) {
                    HStack {
                        Button(action: { settings.startTimer() }) {
                            VStack {
                                Text("Points")
                                
                                Text(string(bool: settings.timerPointsStarted))
                                    .fontWeight(.bold)
                            }
                        }
                        VStack {
                            Button(action: { settings.startTimer() }) {
                                Text("Round")
                            }
                            Text(string(bool: settings.timerRoundStarted))
                                .fontWeight(.bold)
                        }
                        
                        Button(action: { settings.cancelTimers() }) {
                            Text("Reset")
                        }
                    }
                }
                
                Section(header: Text("Size")) {
                    
                    HStack {
                        Text("Padding: ".appendingFormat("%2.0f", padding))
                        Spacer()
                        
                        HStack {
                        Button("+") { padding = padding + CGFloat(1) }
                            .emphasizeCircle()
                        Button("-") { padding = padding - CGFloat(1) }
                            .emphasizeCircle()
                        }
                        .frame(width: 80)
                    }
                    .padding()
                    .background(Color.secondary
                                    .cornerRadius(20))
                }
            }
        }
    }
    
    func string(bool: Bool) -> String {
        bool ? "on" : "off"
    }
}


// MARK: - preview
struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarSampleView()
            .environmentObject(GameSettings())
            .previewLayout(.fixed(width: 480, height: 400))
    }
}

/// title button to select rules and conjure the settings popover in ContentView
struct SettingsButton: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var show: Bool
    
    var body: some View {
        Button() {
            withAnimation() {
                show.toggle()
            }
        } label: {
            Text(settings.rule.description)
                .font(.title)
        }
        /// is this enough to create a context menu on longPress?
        .contextMenu(menuItems: {
            ForEach(settings.possibleRules) { rule in
                Button(rule.description) {
                    settings.rule = rule
                }
            }
        })
        .padding(8)
        .background(Color.background.cornerRadius(10.0))
    }
}
