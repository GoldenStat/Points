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
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    // History Buttons
                    HStack {
                        Button() { settings.undo() }
                            label: {
                                Image(systemName: "arrow.left")
                                    .padding()
                            }
                            .disabled(!settings.canUndo)
                        Button() { settings.redo() }
                            label: {
                                Image(systemName: "arrow.right")
                                    .padding()
                            }
                            .disabled(!settings.canRedo)
                        
                    }
                    
                    Spacer()
                    
                    // Info Button
                    Button() {
                        showInfo.toggle()
                    } label: {
                        Image(systemName:
                                "info")
                            .padding()
                    }
                }
                
                // Drag Down
                Button() {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        presentEditView.toggle()
                    }
                    if !presentEditView {
                        settings.updateSettings()
                    }
                } label: {
                    presentEditView ? Image(systemName: "arrow.up") : Image(systemName: "arrow.down")
                }
                .foregroundColor(.gray)
                .framedClip(borderColor: .clear, cornerRadius: 25.0, lineWidth: 1.0)
                .emphasizeCircle(maxHeight: 60)
                
            }
//            .background(Color.darkNoon)
            .zIndex(2)
            if (presentEditView) {
                VStack(spacing: 0){
                    EditView()
                        .padding()
                        .background(Color.background)
                        .zIndex(1) // let it scroll down from 'behind' the menu bar
                    
                    Color.background.opacity(0.1)
                }
                .transition(.move(edge: .top))
            }
            
            Spacer()
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
    
    // MARK: present Info
    @State var showInfo: Bool = false
    
 }


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
