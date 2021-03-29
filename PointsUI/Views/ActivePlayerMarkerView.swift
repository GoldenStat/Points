//
//  ActivePlayerMarkerView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI


/// the marker shows who is "active", e.g. the dealer
struct ActivePlayerMarkerView: View {
 
    class Token {
        var size: CGFloat = 80
        var origin: CGPoint = CGPoint(x: 200, y: 80)
        var location: CGPoint = CGPoint(x: 80, y: 80)
        var delta: CGSize = .zero
        
        /// consists of startLocation + delta
        var currentLocation : CGPoint {
            location.applying(.init(translationX: delta.width, y: delta.height))
        }
    }

    var token = Token()
    @Binding var activeIndex: Int?
    var rects: [CGRect]
    
    var body: some View {
        Circle()
            .frame(width: token.size, height: token.size)
            .opacity(0.8)
            .gesture(dragGesture)
    }
    
    // MARK: - handle token position
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged() { dragValue in
                token.delta = dragValue.translation
                updateActiveIndex(in: rects)
            }
            .onEnded() { value in
                updateActiveIndex(in: rects)
                updateLocation(for: token, to: activeIndex, rects: rects)
            }
    }
    
    /// figure out nearest view to Token position
    func updateActiveIndex(in rects: [CGRect]) {
        var nearestDistance: CGFloat = .infinity
        for (index,rect) in rects.enumerated() {
            let distanceToLocation = rect.center.squareDistance(to: token.currentLocation)
            if nearestDistance > distanceToLocation {
                nearestDistance = distanceToLocation
                activeIndex = index
            }
        }
    }
    
    /// called when the move gesture ends
    /// moves the token to the active Frame
    func updateLocation(for token: Token, to index: Int?, rects: [CGRect]) {
        let padding = token.size / 2
        let markerSize = token.size
        
        guard let index = index else { token.location = token.origin; return }
        token.location = location(for: index, and: rects[index])
        token.delta = .zero
        
        /// get token Location for a given index
        ///
        /// orientates itself on the Grid's tokenEdge method
        /// defaults to center of the frame
        
        func location(for index: Int, and frame: CGRect ) -> CGPoint {
            let item = PlayerGrid(index: index)
            let distanceFromEdge = padding + markerSize / 2
            let newTokenLocation : CGPoint
            
            if item.tokenEdge == Edge.Set.top {
                // move token above the frame
                newTokenLocation = CGPoint(
                    x: frame.midX,
                    y: frame.minY - distanceFromEdge
                )
            } else if item.tokenEdge == Edge.Set.bottom {
                // move token below the frame
                newTokenLocation = CGPoint(
                    x: frame.midX,
                    y: frame.maxY + distanceFromEdge
                )
            } else if item.tokenEdge == Edge.Set.leading {
                // move token left the frame ... not right if .leading is not "left"
                newTokenLocation = CGPoint(
                    x: frame.minX - distanceFromEdge + padding / 4 * 3,
                    y: frame.midY
                )
            } else if item.tokenEdge == Edge.Set.trailing {
                // move token right of the frame
                newTokenLocation = CGPoint(
                    x: frame.maxX + distanceFromEdge - padding / 4 * 3,
                    y: frame.midY
                )
            } else {
                newTokenLocation = CGPoint(
                    x: frame.midX,
                    y: frame.minY + distanceFromEdge
                )
            }
            
            return newTokenLocation
        }
        
    }
}


extension VerticalAlignment {
    private enum MarkerAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[VerticalAlignment.center]
        }
    }
    
    static let markerAlignment = VerticalAlignment(MarkerAlignment.self)
}
