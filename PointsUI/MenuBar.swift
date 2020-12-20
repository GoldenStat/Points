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
                    if settings.timerRoundStarted {
                        CountdownView(totalTimeInterval: settings.timeIntervalToCountRound - settings.timeIntervalToCountPoints,
                                      color: Color.points)
                            .opacity(0.3)
                            .aspectRatio(contentMode: .fit)
                    } else if settings.timerPointsStarted {
                        CountdownView(totalTimeInterval: settings.timeIntervalToCountPoints,
                                      color: Color.pointbuffer)
                            .opacity(0.3)
                            .aspectRatio(contentMode: .fit)
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
    @State private var showEditView = false
    @State private var showInfo = false
    
    var body: some View {
        MenuBar(showEditView: $showEditView,
                showInfo: $showInfo)
            .sheet(isPresented: $showEditView) {
                EditView()
            }
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarSampleView()
            .environmentObject(GameSettings())
//            .previewLayout(.fixed(width: 480, height: 100))
    }
}
