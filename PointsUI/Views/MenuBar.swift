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
    
    @State var showInfo: Bool = false
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
                ZStack {
                    HStack {
                        // History Buttons
                        historyButtons
                        
                        Spacer()
                        
                        // Info Button
                        infoButton
                    }
                    
                    // Drag Down
                    editViewButton
                    
                }
                .zIndex(2)
                
                if (presentEditView) {
                    VStack(spacing: noSpacing){
                        EditView()
                            .padding()
                            .zIndex(1) // let it scroll down from 'behind' the menu bar
                    }
                    .transition(.move(edge: .top))
                    .background(LinearGradient(gradient: Gradient(colors: [.background,.background,.background,.clear]), startPoint: .top, endPoint: .bottom))
                }
            }
            
            Spacer() // "invisible" part
                .background(Color.background.opacity(invisible))
                .edgesIgnoringSafeArea(.bottom)
        }
        .popover(isPresented: $showInfo) {
            InfoView()
        }
        .onTapGesture(count: 2) {
            withAnimation {
                presentEditView = false
                settings.updateSettings()
            }
        }
    }
        
    // MARK: - constants
    let maxButtonHeight: CGFloat = 60
    let animationDuration: Double = 2.5
    let noSpacing: CGFloat = 0
    let invisible: Double = 0.01
    
    
    // MARK: - Menu Bar symbols
    
    // MARK: editView button
    var editViewButton: some View {
        Button() {
            withAnimation(.easeInOut(duration: animationDuration)) {
                presentEditView.toggle()
            }
            if !presentEditView {
                settings.updateSettings()
            }
        } label: {
            editViewSymbol
        }
        .foregroundColor(.gray)
        .framedClip(borderColor: .clear)
        .emphasizeCircle(maxHeight: maxButtonHeight)
    }
    
    var editViewSymbol: some View {                         presentEditView ? Image(systemName: "arrow.up") : Image(systemName: "arrow.down")
    }
    
    // MARK: info button

    var infoButton: some View {
        Button() {
            showInfo.toggle()
        } label: {
            Image(systemName:
                    "info")
                .padding()
        }
    }
    
    // MARK: history buttons
    var historyButtons: some View {
        HStack {
            Button() { settings.undo() }
                label: {
                    undoSymbol
                        .padding()
                }
                .disabled(!settings.canUndo)
            Button() { settings.redo() }
                label: {
                    redoSymbol
                        .padding()
                }
                .disabled(!settings.canRedo)
        }
    }
    
    var undoSymbol: some View { Image(systemName: "arrow.left")}
    var redoSymbol: some View { Image(systemName: "arrow.right")}
 
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
