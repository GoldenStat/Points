//
//  HistorySymbolRow.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct HistorySymbolRow: View {
    @EnvironmentObject var settings: GameSettings
    
    @State var activeSide: OverlayHistorySymbol.Side?
    @State var animationStateLeft: OverlayHistorySymbol.AnimationState = OverlayHistorySymbol.initial
    @State var animationStateRight: OverlayHistorySymbol.AnimationState = OverlayHistorySymbol.initial

    var body: some View {
        return HStack {
            OverlayHistorySymbol(active: activeSide == .left, side: .left, state: animationStateLeft)
            Spacer()
            OverlayHistorySymbol(active: activeSide == .right, side: .right, state: animationStateRight)
        }
        .padding()
    }
    
    
    var dragGesture : some Gesture {
        DragGesture()
            .onChanged() { value in
                if value.translation.width < 0 {
                    activeSide = .left
                    animationStateLeft = OverlayHistorySymbol.selected
                    animationStateRight = OverlayHistorySymbol.initial

                } else {
                    activeSide = .right
                    animationStateLeft = OverlayHistorySymbol.initial
                    animationStateRight = OverlayHistorySymbol.selected
                }
            }
            .onEnded() { _ in
                animationStateLeft = OverlayHistorySymbol.final
                animationStateRight = OverlayHistorySymbol.final
//                activeSide = nil
            }
    }

}

struct OverlayHistorySymbol: View {
    var active = false
    let side : Side
    
    var animation : Animation? {
        if active {
            return .easeOut(duration: fadeOutSpeed)
        } else {
            return nil
        }
    }
    
    static let initial = AnimationState(opacity: 0.6, scale: 1.0, offset: CGSize.zero)
    static let selected = AnimationState(opacity: 0.9, scale: 1.4, offset: CGSize.zero)
    static let final = AnimationState(opacity: 0.0, scale: 0.0, offset: CGSize.zero)

    // MARK: - constants
    let fadeOutSpeed: Double = 1.0

    /// create static constant for different animation states
    struct AnimationState {
        let opacity : Double
        let scale : CGFloat
        let offset : CGSize
    }
    
    var state : AnimationState

    enum Side { case left, right, both }
    
    private let initialFontSize: CGFloat = 100

    @ViewBuilder var image: some View {
        switch side {
            case .left:
                Image(systemName: "arrow.left.circle")
        case .right:
            Image(systemName: "arrow.right.circle")
        case .both:
            HStack {
                Image(systemName: "arrow.left.circle")
                Image(systemName: "arrow.right.circle")
            }
        }
    }
    
    var body: some View {
        image
            .font(.system(size: initialFontSize))
            .opacity(state.opacity)
            .scaleEffect(state.scale)
            .animation(.easeInOut(duration: 5.0))
    }
}

struct TestHistorySymbols: View {
    @State var showSymbols = true
    @State var isDragging = false
    
    var body: some View {
        ZStack {
            HistorySampleView()
            if showSymbols {
                HistorySymbolRow()
            }
        }
    }
}

struct HistorySymbol_Previews: PreviewProvider {
    static var previews: some View {
        TestHistorySymbols()
            .environmentObject(GameSettings())
    }
}
