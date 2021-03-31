//
//  ActivePlayerMarkerView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

/// Main components of the token are it's original position, a manipulatatble
///
/// change the delta to it's original position -> the location is calculated as delta to it's last location
/// change the activeIndex (index of the referring rect) -> the lastPosition is updated regarding on the geometry of this rect. Delta is reset
/// calling updateLocation() -> the nearest center of the rects is found, and lastPosition is updated in reference to that rect
///
class Token : ObservableObject {
    var size: CGFloat = 80
    private var origin: CGPoint = CGPoint(x: 200, y: 80)
    @Published var location: CGPoint = CGPoint(x: 80, y: 80)
    @Published var delta: CGSize = .zero
    /// consists of startLocation + delta
    var currentLocation : CGPoint {
        location.applying(.init(translationX: delta.width, y: delta.height))
    }

    @Published var activeIndex: Int? = nil
    @Published var rects: [CGRect]

    init(for number: Int) {
        rects = Array<CGRect>(repeating: CGRect(), count: number)
    }
    
    public var activeFrame: CGRect? {
        if let index = activeIndex, index < rects.count, index > 0 {
            return rects[activeIndex!]            
        }
        return nil
    }
    
    func update(activeIndex: Int?, rects: [CGRect]) {
        self.activeIndex = activeIndex
        self.rects = rects
    }
        
    public func update(activeIndex: Int?) {
        self.activeIndex = activeIndex
    }
    
    public func update(rects: [CGRect]) {
        self.rects = rects
    }

    public func update(translation: CGSize) {
        delta = translation
        activateNearestRect()
    }

    public func resetPosition() {
        delta = .zero
        location = origin
    }
        
    public func activateNearestRect() {
        var nearestDistance: CGFloat = .infinity
        for (index,rect) in rects.enumerated() {
            let distanceToLocation = rect.center.squareDistance(to: currentLocation)
            if nearestDistance > distanceToLocation {
                nearestDistance = distanceToLocation
                activeIndex = index
            }
        }
    }

    /// called when the move gesture ends
    /// moves the token to the active Frame
    /// needed if token Index Is set
    public func moveToActiveRect() {
        
        guard let index = activeIndex, index > 0, index < rects.count else { self.location = origin; return } // reset location if no activeIndex is set
        
        
        self.location = location(for: index, and: rects[index])
        delta = .zero
        
        /// get token Location for a given index
        ///
        /// orientates itself on the Grid's tokenEdge method
        /// defaults to center of the frame


        func location(for index: Int, and frame: CGRect ) -> CGPoint {
            var padding : CGFloat { size / 2 }
            var markerSize : CGFloat { size }

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

/// the marker shows who is "active", e.g. the dealer and puts a frame around the active one
struct ActivePlayerMarkerView: View {
    @EnvironmentObject var settings: GameSettings
    var token : Token { settings.token }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: token.size, height: token.size)
                .opacity(0.8)
                .overlay(
                    Text ("T")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
                .position(token.currentLocation)

            if let activeRect = token.activeFrame {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .border(Color.green)
                    .frame(width: activeRect.width,
                           height: activeRect.height)
            }
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
