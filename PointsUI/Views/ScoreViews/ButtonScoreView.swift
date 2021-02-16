//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// One of the views that you can drag points out of... therefore, it has an .onDrag-modifier.
/// this modifier must comply to the .onDrop in the playerView
struct ButtonScoreView: View {
    @EnvironmentObject var settings: GameSettings
    var score: Score
        
    var body: some View {
        ZStack {
            /// main View to fix space
            Text("000")
                .padding()
                .foregroundColor(.clear)
            Text(score.value.description)
        }
        .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
        .fixedSize(horizontal: true, vertical: false)
        .foregroundColor(.points)
        .overlay(bufferView
        )
    }
  
    private let scoreSize : CGFloat = 122
    private let bufferScoreSize : CGFloat = 180.0

    @ViewBuilder var bufferView: some View {
        if score.buffer > 0 {
            Text(score.buffer.description)
                .font(.system(size: bufferScoreSize, weight: .semibold, design: .rounded))
                .fixedSize()
                .foregroundColor(.blue)
                .scaleEffect(bufferParam.scaleFactor)
                .onDrag() {
                    settings.cancelTimers() // timers  must be started in onDrop
                    settings.pointBuffer = score.buffer
                    return NSItemProvider(object: "\(score.buffer)" as NSString)
                }
                .background(Color.white.opacity(0.6).cornerRadius(25).blur(radius: 20.0))
                .offset(bufferParam.offset)
                .onAppear() {
                    withAnimation {
                        bufferParam = .final
                    }
                }
                .onDisappear() {
                    withAnimation {
                        bufferParam = .appear
                    }
                }
        } else {
            EmptyView()
        }
    }

    // MARK: - private variables
    @State private var bufferParam: BufferParameters = .appear
    
    struct BufferParameters {
        var scaleFactor: CGFloat
        var offset: CGSize
        static let appear = BufferParameters(scaleFactor: 0.3, offset: .zero)
        static let final = BufferParameters(scaleFactor: 0.6, offset: CGSize(width: 40, height: -80))
    }
}


struct ButtonScorePreviewView: View {
    @State var settings = GameSettings()
    @State var score = Score(11, buffer: 3)
    var body: some View {
        Color.background
            .overlay(
        ButtonScoreView(score: score)
            .onTapGesture(count: 2) {
                withAnimation {
                score.save()
                }
            }
            .simultaneousGesture(
                TapGesture(count: 1)
                    .onEnded() {
                        withAnimation {
                    score.add(points: 1)
                        }
                })
        )
            .environmentObject(settings)
    }
}
struct ButtonScoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonScorePreviewView()
    }
}
