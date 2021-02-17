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
     
    @State private var scaleFactor: CGFloat = 0.8
    
    // the text should be the biggest possible to look good, so we would get our available area, select a "box" out of it and calculate the best size
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.height,geo.size.width)
                Text(score.value.description)
                    .font(.system(size: size * scaleFactor, weight: .semibold, design: .rounded))
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: size, height: size, alignment: .center)
        }
            .scaledToFill()
            .foregroundColor(.points)
            .overlay(bufferView)
            .background(Color.white.opacity(0.5))
    }
    
    let debugViewSize = true
    var bgColor: Color { debugViewSize ? .white.opacity(0.5) : .clear }
  
    @ViewBuilder var bufferView: some View {
        if score.buffer > 0 {
                Text(score.buffer.description)
                    .font(bufferParam.font)
                    .fixedSize()
                .foregroundColor(.blue)
                .scaleEffect(bufferParam.scaleFactor * scaleFactor)
                .onDrag() {
                    settings.cancelTimers() // timers  must be started in onDrop
                    settings.pointBuffer = score.buffer
                    return NSItemProvider(object: "\(score.buffer)" as NSString)
                }
                .background(Color.white.opacity(0.6).cornerRadius(25).blur(radius: 20.0))
                .offset(bufferParam.offset)
                .onAppear() {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.4, blendDuration: 0.5)) {
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
        var font: Font = .system(size: 180.0, weight: .semibold, design: .rounded)
        static let appear = BufferParameters(scaleFactor: 0.3, offset: .zero)
        static let final = BufferParameters(scaleFactor: 0.8, offset: CGSize(width: 80, height: -80))
    }
}


struct ButtonScorePreviewView: View {
    @State var settings = GameSettings()
    @State var score = Score(1, buffer: 3)
    @State var size : CGSize
    
    var body: some View {
        VStack {
            Color.background
                .overlay(
//                    LazyHGrid(rows: [GridItem(.flexible()),GridItem(.flexible())]) {
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(1..<4) { _ in
                                button
                                
                            }
                        }
//                    }
                )
                .frame(width: size.width, height: size.height)
                .environmentObject(settings)

            HStack {
                VStack {
                    Slider(value: $size.height,
                           in: height.min ... height.max,
                           step: 5)
                    label: do { Text("height") }
                    Text(size.height.description)
                }
                VStack {
                    Slider(value: $size.width,
                           in: width.min ... width.max,
                           step: 5)
                    label: do { Text("width") }
                    Text(size.width.description)
                }
            }
        }
    }
    
    let height = (min: CGFloat(60), max: CGFloat(600))
    let width = (min: CGFloat(60), max: CGFloat(500))
        
    @ViewBuilder var button: some View {
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
    }
}
struct ButtonScoreView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonScorePreviewView(size: CGSize(width: 200, height: 400))
    }
}
