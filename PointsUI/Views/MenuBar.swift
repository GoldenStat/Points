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
        VStack {
            Group { // visible part
                if (presentEditView) {
                    VStack(spacing: noSpacing){
                        
                        Color.background
                            .edgesIgnoringSafeArea(.top)
                        
                        EditView()
                            .padding()
                            .background(Color.background)
                            .shadow(color: Color.accentColor, radius: 10, x: 5, y: 5)
                        
                        Color.background
                        
                        LinearGradient(gradient: Gradient(colors: [.background,.background,.pointsTop]), startPoint: .top, endPoint: .bottom)
                    }
                    .transition(.move(edge: .top))
                    .frame(maxHeight: 400)
                }
            }
            
            Color.background // "invisible" part
                .opacity(invisible)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
        
    // MARK: - constants
    let maxButtonHeight: CGFloat = 60
    let animationDuration: Double = 1.5
    let noSpacing: CGFloat = 0
    let littleSpacing: CGFloat = 10
    let invisible: Double = 0.01
    
    
    // MARK: - Menu Bar symbols
    
    // MARK: editView button
    var EditViewButton: some View {
        Button() {
            withAnimation(.easeInOut(duration: animationDuration)) {
                presentEditView.toggle()
            }
        } label: {
            editViewSymbol
        }
        .foregroundColor(.gray)
        .framedClip(borderColor: .clear)
        .emphasizeCircle(maxHeight: maxButtonHeight)
    }
    
    var editViewSymbol: some View {
        presentEditView ? Image(systemName: "arrow.up") : Image(systemName: "arrow.down")
    }
 
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
        SampleEditView()
    }
}
