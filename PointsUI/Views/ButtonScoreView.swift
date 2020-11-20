//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ButtonScoreView: View {
    
    var score: Score
    
    @State private var scaleFactor: CGFloat = 0.3
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Text(score.value.description)
                .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
                .foregroundColor(.points)
                .padding()
                .overlay(bufferView)
        }
    }
    
    @ViewBuilder var bufferView: some View {
        if score.buffer > 0 {
            Text(score.buffer.description)
                .font(.system(size: bufferScoreSize, weight: .semibold, design: .rounded))
                .foregroundColor(.blue)
                .background(Color.white
                                .opacity(0.05)
                                .cornerRadius(20.0)
                                .blur(radius: 2.0)
                                )
                
                .scaleEffect(finalScaleFactor)
                .offset(offset)
                .onAppear() {
                    withAnimation() {
                        scaleFactor = finalScaleFactor
                        offset = finalOffset
                    }
                }
        } else {
            EmptyView()
        }
    }
    
    // MARK: - private variables
    
    private let scoreSize : CGFloat = 144
    private let bufferScoreSize : CGFloat = 180.0
    private var scoreOpacity : Double { score.buffer > 0 ? 0.3 : 1.0 }
    private let finalScaleFactor : CGFloat = 0.3
    private let finalOffset = CGSize(width: 40, height: -80)
}


struct ButtonScorePreviewView: View {
    @State var score = Score(0, buffer: 3)
    var body: some View {
        Color.gray
            .overlay(
        ButtonScoreView(score: score)
            .onTapGesture(count: 2) {
                score.value += 1
            }
            .simultaneousGesture(
                TapGesture(count: 1)
                    .onEnded() {
                    score.buffer += 1
                })
        )
    }
}
struct ButtonScoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonScorePreviewView()
    }
}
