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
                        
                        if showHistoryActionSymbol {
                            HistoryActionView(systemName: symbolName)
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
                if showHistory {
                    withAnimation() {
                        showHistory = false
                    }
                }
            }
            .gesture(dragStatusBar)
            .simultaneousGesture(historyActionGesture)
            .gesture(showHistoryGesture)

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
    
    @State var symbolName: String = ""
    
    var historyActionGesture: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onChanged() { gesture in
                showHistoryActionSymbol = true
            }
            .sequenced(before: historyDrag)
    }
    
    @State var showHistoryActionSymbol: Bool = false
    var historyDrag: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.x < value.startLocation.x {
                    withAnimation() {
                        settings.undo()
                        symbolName = "arrow.left"
                    }
                }
                if value.location.x > value.startLocation.x {
                    withAnimation() {
                        settings.redo()
                        symbolName = "arrow.right"
                    }
                }
            }
            .onEnded() { value in
                if value.location.x < value.startLocation.x {
                    withAnimation() {
                        settings.undo()
                    }
                }
                if value.location.x < value.startLocation.x {
                    withAnimation() {
                        settings.redo()
                    }
                }
                showHistoryActionSymbol = false
                symbolName = ""
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
