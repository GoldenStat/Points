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
    
    @Binding var presentEditView: Bool
    
    var editViewOffset: CGFloat { presentEditView ? endOffset : startOffset }
    
    let startOffset: CGFloat = -200 // height + safe area
    let endOffset: CGFloat = 0
    
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
                } label: {
                    presentEditView ? Image(systemName: "chevron.compact.up") : Image(systemName: "chevron.compact.down")
                }
                .font(.largeTitle)

            }
            .foregroundColor(.gray)
            .background(Color.darkNoon
                            .edgesIgnoringSafeArea(.top)
)


//            if presentEditView {
                EditView()
                    .background(Color.darkNoon)
                    .offset(x: 0, y: editViewOffset)
                    .animation(.default)
                    .onDisappear() {
                        settings.updateSettings()
                    }
                    .zIndex(-1)

//            }
            Spacer()

        }

    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBar(presentEditView: .constant(true))
    }
}
