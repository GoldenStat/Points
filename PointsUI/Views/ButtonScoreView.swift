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
    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 1.0 }
    
    @State var scaleFactor: CGFloat = 0.1
    @State var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Text(score.value.description)
                .font(.system(size: 144, weight: .semibold, design: .rounded))
                .fixedSize()
            
            if score.buffer > 0 {
                Text(score.buffer.description)
                    .font(.system(size: 180, weight: .semibold, design: .rounded))
                    .fixedSize()
                    .foregroundColor(.blue)
                    .fixedSize()
                    .scaleEffect(scaleFactor)
                    .offset(offset)
                    .onAppear() {
                        withAnimation(.linear(duration: 1.0)) {
                            scaleFactor = 0.5
                            offset = CGSize(width: 100, height: -80)
                        }
                    }
            }
        }
    }
}

struct ButtonScorePreviewView: View {
    @State var score = Score(0)
    var body: some View {
        ButtonScoreView(score: score)
            .onTapGesture(count: 2) {
                score.value += 1
            }
            .simultaneousGesture(
                TapGesture(count: 1)
                    .onEnded() {
                    score.buffer += 1
                })
    }
}
struct ButtonScoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonScorePreviewView(score: Score(10, buffer: 0))
    }
}
