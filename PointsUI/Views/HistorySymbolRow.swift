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
    @State var animationState: OverlayHistorySymbol.AnimationState = OverlayHistorySymbol.initial
    
    var body: some View {
        return HStack {
            OverlayHistorySymbol(active: activeSide == .left, side: .left, state: animationState)
            Spacer()
            OverlayHistorySymbol(active: activeSide == .right, side: .right, state: animationState)
        }
        .padding()
        .gesture(dragGesture)
    }
    
    var dragGesture : some Gesture {
        DragGesture()
            .onChanged() { value in
                if value.translation.width < 0 {
                    activeSide = .left
                } else {
                    activeSide = .right
                }
                animationState = OverlayHistorySymbol.selected
            }
            .onEnded() { _ in
                animationState = OverlayHistorySymbol.final
                activeSide = nil
            }
    }

}

struct OverlayHistorySymbol: View {
    @State var active = false
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

    enum Side {
        case left, right
        var name: String {
            switch self {
            case .left: return "arrow.left.circle"
            case .right: return "arrow.right.circle"
            }
        }
    }
    
    private let initialFontSize: CGFloat = 100

    var image: some View {
        Image(systemName: side.name)
            .font(.system(size: initialFontSize))
            .opacity(state.opacity)
            .scaleEffect(state.scale)
    }
    
    var body: some View {
        image
            .animation(animation)
    }
}

struct HistorySymbol_Previews: PreviewProvider {
    static var previews: some View {
        HistorySymbolRow()
            .environmentObject(GameSettings())
    }
}
