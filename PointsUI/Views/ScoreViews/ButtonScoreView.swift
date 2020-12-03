//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ButtonScoreView: View {
    
    @Namespace var nspace
    
    var score: Score
    
    @State private var scaleFactor: CGFloat = 0.3
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Text("00")
                .padding()
                .foregroundColor(.clear)
            Text(score.value.description)
        }
        .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
        .fixedSize(horizontal: true, vertical: false)
        .scaleEffect(0.8)
        .foregroundColor(.points)
        .matchedGeometryEffect(id: "bufferEffect", in: nspace, properties: .frame, anchor: .center, isSource: true)
        .overlay(bufferView)
    }
    
    @ViewBuilder var bufferView: some View {
        if score.buffer > 0 {
            ZStack {
                Text("00")
                    .foregroundColor(.clear)
                    .padding()
                Text(score.buffer.description)
            }
            .font(.system(size: bufferScoreSize, weight: .semibold, design: .rounded))
            .fixedSize()
            .foregroundColor(.blue)
            .scaleEffect(finalScaleFactor)
            .offset(offset)
//            .onAppear() {
//                withAnimation() {
//                    scaleFactor = finalScaleFactor
//                    offset = finalOffset
//                }
//            }
//            .onDisappear() {
//                scaleFactor = 0.3
//                offset = CGSize.zero
//            }
            .matchedGeometryEffect(id: "bufferEffect", in: nspace, properties: .frame, anchor: .center, isSource: false)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - private variables
    
    private let scoreSize : CGFloat = 122
    private let bufferScoreSize : CGFloat = 180.0
    private var scoreOpacity : Double { score.buffer > 0 ? 0.3 : 1.0 }
    private let finalScaleFactor : CGFloat = 0.3
    private let finalOffset = CGSize(width: 40, height: -60)
}


struct ButtonScorePreviewView: View {
    @State var score = Score(11, buffer: 3)
    var body: some View {
        Color.background
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
