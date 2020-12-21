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
    var padding: CGFloat = 10
    
    var body : some View {
        ZStack {
            HStack {
                Button(action: { settings.undo() }, label: { Image(systemName: "arrow.left") })
                Button(action: { settings.redo() }, label: { Image(systemName: "arrow.right") })
                Spacer()
            }
            
            
            Button() {
                withAnimation() {
                    showEditView.toggle()
                }
            } label: {
                Text(settings.rule.description)
                    .font(.title)
            }
            
            HStack {
                Spacer()
                ZStack {
                    if settings.timerPointsStarted {
                        ActiveCircleView()
                            .aspectRatio(contentMode: .fit)
                            .padding(padding)
                    } else if settings.timerRoundStarted {
                        CountdownView(totalTimeInterval: settings.timeIntervalToCountRound - settings.timeIntervalToCountPoints,
                                      color: Color.points)
                            .opacity(0.3)
                            .aspectRatio(contentMode: .fit)
                            .padding(padding)
                    } else {
                        Button() {
                            showInfo.toggle()
                        } label: {
                            Image(systemName:
                                    "info")
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.background.cornerRadius(10.0))
        .padding(5.0)
        .background(Color.white.opacity(0.3).cornerRadius(10.0))
        .frame(height: 40)
        
    }
    
}

struct MenuBarSampleView: View {
    @EnvironmentObject var settings : GameSettings
    @State private var showEditView = false
    @State private var showInfo = false
    @State private var padding : CGFloat = 10
    
    var body: some View {
        VStack {
            MenuBar(showEditView: $showEditView,
                    showInfo: $showInfo, padding: padding)
                .sheet(isPresented: $showEditView) {
                    EditView()
                }
                .sheet(isPresented: $showInfo) {
                    InfoView()
                }
            VStack {
                Section(header: Text("Timer")) {
                    HStack {
                        Button(action: { settings.timerPointsStarted.toggle() }) {
                            VStack {
                                Text("Points")
                                
                                Text(string(bool: settings.timerPointsStarted))
                                    .fontWeight(.bold)
                            }
                        }
                        VStack {
                            Button(action: { settings.timerRoundStarted.toggle() }) {
                                Text("Round")
                            }
                            Text(string(bool: settings.timerRoundStarted))
                                .fontWeight(.bold)
                        }
                        
                        Button(action: { settings.timerPointsStarted = false; settings.timerRoundStarted = false }) {
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
            .previewLayout(.fixed(width: 480, height: 100))
    }
}
