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
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    if (!hideStatusBar) {
                        TopMenuBar()
                            .scaledToFit()
                    }
                    
                    MainGameView()
                    
                    if (!hideStatusBar) {
                        BottomMenuBar(showEditView: $showEditView,
                                      showInfo: $showInfo,
                                      backAction: { settings.undo() },
                                      forwardAction: { settings.redo() }
                        )
                    }
                }
                
            }
            .statusBar(hidden: true)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(settings.rule.description)
            .gesture(dragStatusBar)
            .popover(isPresented: $showInfo) {
                InfoView()
            }
            .popover(isPresented: $showEditView) {
                EditView()
                    .environmentObject(settings)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(settings)
    }
    
    @State private var hideStatusBar = false
    var dragStatusBar : some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged() { value in
                if value.location.y < value.startLocation.y {
                    withAnimation() {
                        hideStatusBar = false
                    }
                } else if value.location.y > value.startLocation.y {
                    withAnimation() {
                        hideStatusBar = true
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
