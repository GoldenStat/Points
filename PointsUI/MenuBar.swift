//
//  BottomMenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 18.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MenuBar : View {
    @EnvironmentObject var settings: GameSettings
    @Binding var showEditView: Bool
    @Binding var showInfo: Bool
    @Binding var showHistory: Bool
    
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
                Button(action: { showHistory.toggle() }, label: {
                    Image(systemName: "doc.plaintext")
                })
                Spacer()
            }
            .padding(.horizontal)

            RightSymbolView(toggle: $showInfo)
                .padding(.horizontal)
        }
        .frame(height: 50)
    }
    
}

struct MenuBarSampleView: View {
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

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarSampleView()
            .environmentObject(GameSettings())
            .previewLayout(.fixed(width: 480, height: 400))
    }
}

struct RightSymbolView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var toggle: Bool
    
    let paddingAmount : CGFloat = 10
    
    var body: some View {
        HStack {
            Spacer()
            ZStack {
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
                        toggle.toggle()
                    } label: {
                        Image(systemName:
                                "info")
                    }
                    .padding(.trailing)
                }
            }
        }
    }
}
