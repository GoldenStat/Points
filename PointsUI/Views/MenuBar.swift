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
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button() { settings.undo() }
                        label: {
                            Image(systemName: "arrow.uturn.left")
                                .padding()
                        }
                    Button() { settings.redo() }
                        label: {
                            Image(systemName: "arrow.uturn.right")
                                .padding()
                        }
                    
                    Spacer()
                    
                }
                
                Button() {
                    presentEditView.toggle()
                    if !presentEditView {
                        settings.updateSettings()
                    }
                } label: {
                    presentEditView ? Image(systemName: "chevron.compact.up") : Image(systemName: "chevron.compact.down")
                }
                .font(.largeTitle)
                
            }
            .foregroundColor(.gray)
            .background(Color.darkNoon
                            .edgesIgnoringSafeArea(.top)
            )
            
            EditView()
                .background(Color.darkNoon)
                .offset(x: 0, y: editViewOffset)
                .animation(.default)
                .zIndex(-1) // let it scroll down from 'behind' the menu bar
            
            Spacer()
            
        }
        // now, create an 'invisible' background that handles doubletaps
        .background(presentEditView ? backgroundAlmostInvisible : backgroundNotRespondigToClicks)
        .onTapGesture() {
            presentEditView = false
        }
        
        
    }
    
    // MARK: handle EditView appearance
    @Binding var presentEditView: Bool
    var editViewOffset: CGFloat { presentEditView ? endOffset : startOffset }
    
    let startOffset: CGFloat = -200 // height + safe area
    let endOffset: CGFloat = 0
    let backgroundAlmostInvisible = Color.white.opacity(0.01)
    let backgroundNotRespondigToClicks: Color = Color.clear
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBar(presentEditView: .constant(true))
    }
}
