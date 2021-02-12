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

        /// editView display control
    @Binding var showEditView: Bool

        /// info display control
    @Binding var showInfo: Bool

        /// History control (with step counter for preview)
    @Binding var showHistory: Bool
    var steps: Int = 0
        
    var body : some View {
        ZStack {
            Group {
                ZStack {
                    
                    Button() {
                        withAnimation() {
                            showEditView.toggle()
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
                }
            }
            .padding(8)
            .background(Color.background.cornerRadius(10.0))
            
            HStack {
                HistoryMenuSymbol(
                    show: $showHistory,
                    counter: steps)
                Spacer()
                InfoMenuSymbol(show: $showInfo)
            }
                .padding(.horizontal)
        }
        .frame(height: 50)
    }
}

// MARK: - subviews

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
                Text(counter.description)
                    .opacity(0.4)
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
    
    let paddingAmount : CGFloat = 10
    
    var body: some View {
        Group {
            if settings.timerPointsStarted {
                ActiveCircleView()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if settings.timerRoundStarted {
                CountdownView(totalTimeInterval: settings.timeIntervalToCountRound,
                              color: Color.points)
                    .opacity(0.3)
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Button() {
                    show.toggle()
                } label: {
                    Image(systemName:
                            "info")
                }
                .padding(.trailing)
            }
        }
    }
}

// MARK: - sample View
/// sample view only for showing what menu would look like, starts / stops timer
fileprivate struct MenuBarSampleView: View {
    @EnvironmentObject var settings : GameSettings
    @State private var showEditView = false
    @State private var showInfo = false
    @State private var showHistory = false
    @State private var padding : CGFloat = 10
    
    var body: some View {
        VStack {
            MenuBar(showEditView: $showEditView,
                    showInfo: $showInfo,
                    showHistory: $showHistory
            )
            .sheet(isPresented: $showEditView) {
                EditView()
            }
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
            VStack {
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
                        Button("+") { padding = padding + CGFloat(1) }
                        Button("-") { padding = padding - CGFloat(1) }
                    }
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
