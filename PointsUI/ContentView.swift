//
//  ContentView.swift
//  PointsUI
//
//  Created by Alexander Völz on 30.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var settings : GameSettings = GameSettings()
        
    @State var showInfo: Bool = false
    @State var showEditView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.boardbgColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    MenuBar(showEditView: $showEditView,
                            showInfo: $showInfo)
                        .offset(x: 0, y: hideStatusBar ? -200 : 60)
                    
                    ZStack {
                        MainGameView()
                            .blur(radius: blurRadius)
                        
                        
                        // MARK: History Views
                        if showHistoryControls {
                            HistoryControlView(showHistory: $showHistory)
                        }
                                                
                        if showHistory {
                            GeometryReader { geo in
                                historyView(sized: geo.size)
                            }
                        }
                    }
                }
            }
            .statusBar(hidden: true)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(settings.rule.description)
            .onTapGesture {
                
                withAnimation() {
                    showHistory = false
                    showHistoryControls = false
                }
                
            }
            .gesture(dragStatusBar)
            .onLongPressGesture {
                withAnimation() {
                    showHistoryControls = true
                }
            }

            .popover(isPresented: $showInfo) {
                InfoView()
            }
            .popover(isPresented: $showEditView) {
                NavigationView {
                    EditView()
                }
                .environmentObject(settings)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(settings)
    }
    
    
    // MARK: - History View
    @State private var showHistory: Bool = false
    @State private var showHistoryControls: Bool = false
    
    private  var showHistoryGesture : some Gesture {
        TapGesture(count: 2)
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
            .transition(.opacity)
            .padding()
            .padding(.top)
    }
    
    @State private var hideStatusBar = true
    var dragStatusBar : some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.y < value.startLocation.y && !hideStatusBar {
                    withAnimation() {
                        hideStatusBar = true
                    }
                } else if value.location.y > value.startLocation.y && hideStatusBar {
                    withAnimation() {
                        hideStatusBar = false
                    }
                }
            }
    }
    
}

/// systemName ist passed to Image(systemName:)
struct HistoryActionView: View {
    var systemName: String
    var body: some View {
        Image(systemName: systemName)
            .font(.largeTitle)
            .scaleEffect(4)
            .opacity(0.4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
