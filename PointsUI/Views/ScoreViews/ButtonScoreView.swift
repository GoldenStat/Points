//
//  ButtonScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a text view that the text size to it's frame
struct ScalingTextView: View {
    var text: String
    var scaleFactor : CGFloat // scale Factor relative to the view's frame

    // if the numbers get too big, we must include that in the calculation
    // if the length is 3 digits, we need to adjust the scale
    private let forceResizeFactor : CGFloat = 0.7 // magic constant for large numbers

    init(_ text: String, scale: CGFloat = 0.8) {
        self.text = text
        if text.count > 2 {
            self.scaleFactor = scale * forceResizeFactor
        } else {
            self.scaleFactor = scale
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.height,geo.size.width)
                Text(text)
                    .font(.system(size: size * scaleFactor, weight: .semibold, design: .rounded))
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: size, height: size, alignment: .center)
        }
        .scaledToFill()
    }
}
    
/// One of the views that you can drag points out of... therefore, it has an .onDrag-modifier.
/// this modifier must comply to the .onDrop in the playerView
struct ButtonScoreView: View {
    @EnvironmentObject var settings: GameSettings
    var score: Score

    var bufferOffset: CGSize = BufferParameters.final.offset
    var scaleFactor: CGFloat = 0.8

    var body: some View {
        ZStack {
            ScalingTextView(score.value.description)
                .foregroundColor(.points)
            bufferView
                .offset(offsetSize)
        }
        .background(bgColor)
    }
    
    let showFrame = false
    var bgColor: Color { showFrame ? .white.opacity(0.5) : .clear }
  
    var bufferColor: Color { score.buffer > 0 ? .blue : .pointbuffer }
    
    @ViewBuilder var bufferView: some View {
        if score.buffer != 0 {
            ScalingTextView(score.buffer.description, scale: scaleFactor)
                .foregroundColor(bufferColor)
                .scaleEffect(bufferParam.scaleFactor)
                .onDrag() {
                    settings.cancelTimers() // timers  must be started in onDrop
                    settings.pointBuffer = score.buffer
                    return NSItemProvider(object: "\(score.buffer)" as NSString)
                }
                .background(Color.white.opacity(0.2).cornerRadius(25).blur(radius: 20.0))
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
    
    private var offsetSize: CGSize { CGSize(width: bufferOffset.width * offsetScale * scaleFactor,
                                            height: bufferOffset.height * offsetScale * scaleFactor) }
    var offsetScale : CGFloat = 1.0

    // MARK: - private variables
    @State private var bufferParam: BufferParameters = .appear
    
    struct BufferParameters {
        var scaleFactor: CGFloat
        var offset: CGSize
        var font: Font = .system(size: 180.0, weight: .semibold, design: .rounded)
        static let appear = BufferParameters(scaleFactor: 0.3, offset: .zero)
        static let final = BufferParameters(scaleFactor: 0.8, offset: CGSize(width: 10, height: -80))
    }
}

struct ButtonScorePreviewView: View {
    @State var settings = GameSettings()
    var score : Score { Score(Int(scoreValue.value), buffer: Int(scoreBuffer.value)) }
    @State var size : CGSize
    @State var offsetScale : CGFloat = 0.3
    
    var body: some View {
        VStack {
            Color.background
                .overlay(
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                        ForEach(1..<4) { _ in
                            button
                            
                        }
                    }
                )
                .frame(width: sizeWidth.value, height: sizeHeight.value)
                .environmentObject(settings)

            LazyVGrid(columns: [GridItem(), GridItem()]) {
                configView($sizeHeight)
                configView($sizeWidth)
                configView($offsetWidth)
                configView($offsetHeight)
                configView($scaleFactor)
                Color.blue.opacity(0.2).cornerRadius(20)
                configView($scoreValue)
                configView($scoreBuffer)
                    .onChange(of: scoreBuffer.value, perform: { value in
                        withAnimation() {
                            offsetScale = value == 0 ? 0.3 : 1.0
                        }
                    })
            }
        }
    }
    
    struct AdjustableParam<T> {
        var value: T
        var min: T
        var max: T
        var stride: T
        var text: String
    }
    
    @State var sizeHeight = AdjustableParam<CGFloat>(
        value: CGFloat(200),
        min: CGFloat(60),
        max: CGFloat(600),
        stride: 5,
        text: "height")
    @State var sizeWidth = AdjustableParam<CGFloat>(
        value: CGFloat(200),
        min: CGFloat(60),
        max: CGFloat(600),
        stride: 5,
        text: "width")
    @State var offsetWidth = AdjustableParam<CGFloat>(
        value: CGFloat(40),
        min: CGFloat(-60),
        max: CGFloat(100),
        stride: 5,
        text: "offset.x")
    @State var offsetHeight = AdjustableParam<CGFloat>(
        value: CGFloat(-40),
        min: CGFloat(-100),
        max: CGFloat(20),
        stride: 5,
        text: "offset.y")
    @State var scaleFactor = AdjustableParam<CGFloat>(
        value: CGFloat(0.8),
        min: CGFloat(0.2),
        max: CGFloat(2.0),
        stride: 0.1,
        text: "bufferScale")
    @State var scoreValue = AdjustableParam<CGFloat>(
        value: CGFloat(50),
        min: CGFloat(-100),
        max: CGFloat(200),
        stride: 10.0,
        text: "scoreValue")
    @State var scoreBuffer = AdjustableParam<CGFloat>(
        value: CGFloat(50),
        min: CGFloat(-100),
        max: CGFloat(200),
        stride: 10.0,
        text: "scoreBuffer")

    func configView(_ binding: Binding<AdjustableParam<CGFloat>>) -> some View {
        let param = binding.wrappedValue
        return VStack {
            Slider(value: binding.value,
                   in: param.min ... param.max,
                   step: param.stride)
            label: do { Text(param.text) }
            Text(param.value.description)
        }
    }

    let height = (min: CGFloat(60), max: CGFloat(600))
    let width = (min: CGFloat(60), max: CGFloat(500))
        
    var offsetSize: CGSize { CGSize(width: offsetWidth.value, height: offsetHeight.value) }
    
    @ViewBuilder var button: some View {
        ButtonScoreView(score: score,
                        bufferOffset: offsetSize,
                        scaleFactor: scaleFactor.value,
                        offsetScale: offsetScale)
            .animation(.default)
    }
}

struct ButtonScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonScorePreviewView(size: CGSize(width: 200, height: 400))
    }
}
