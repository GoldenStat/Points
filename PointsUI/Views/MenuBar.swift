//
//  MenuBar.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MenuBar: View {
    @EnvironmentObject var settings: GameSettings
    
    @Binding // this is a binding so the calling view can blur...
    var presentEditView: Bool
    {
        didSet {
            if !presentEditView { settings.updateSettings() }
        }
    }
       
    var body: some View {
        VStack(spacing: noSpacing) {

            Group { // visible part
                if (presentEditView) {
                    VStack(spacing: noSpacing){
                        
                        Color.background
                            .edgesIgnoringSafeArea(.top)
                        
                        Color.background

                        EditView()
                            .padding()
                        
                        LinearGradient(gradient: Gradient(colors: [ .background, .background, .init(white: 1.0, opacity: invisible)]), startPoint: .top, endPoint: .bottom)
                    }
                    .frame(maxHeight: 600)
                }
            }
            
            Color.background // "invisible" part, so the whole thing gets the touch event
                .opacity(invisible)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
        
    // MARK: - constants
    let maxButtonHeight: CGFloat = 60
    let animationDuration: Double = 0.5
    let noSpacing: CGFloat = 0
    let littleSpacing: CGFloat = 10
    let invisible: Double = 0.01
    
}

// MARK: - preview Views

struct SampleEditView: View {
    @State var isVisible = true
    
    var gameSettings = GameSettings()
    
    var body: some View {
        MenuBar(presentEditView: $isVisible)
            .environmentObject(gameSettings)
    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
            SampleEditView()
        }
    }
}
