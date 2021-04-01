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
/// change the activeIndex (index of the referring rect) -> the lastPosition is updated regarding on the geometry of this rect. Delta is reset
/// calling updateLocation() -> the nearest center of the rects is found, and lastPosition is updated in reference to that rect
///
class Token : ObservableObject {

    var size: CGFloat = 80
    
    private var origin: CGPoint = CGPoint(x: 200, y: 80)
    
    @Published var location: CGPoint = CGPoint(x: 80, y: 80) {
        didSet {
            activateNearestRect()
        }
    }

    public func setup(with numberOfRects: Int) {
        rects = Array<CGRect>(repeating: CGRect(), count: numberOfRects)
    }

    @Published var activeIndex: Int? = nil { didSet {
        moveToActiveRect()
    }}
    
    @Published var rects: [CGRect] = []
    
    /// if our calling view wants to do something with this information (e.g. highligt the area)
    public var activeFrame: CGRect? {
        if let index = activeIndex, index < rects.count, index > 0 {
            return rects[activeIndex!]            
        }
        return nil
    }
            
    /// a controller might want to set the rect we should move to
    public func update(activeIndex: Int?) {
        self.activeIndex = activeIndex
    }
    
    /// called if the referencing rect's bounds change
    public func update(rects: [CGRect]) {
        self.rects = rects
    }

    /// go back to original location (e.g. if the game restarts / no player got activated)
    public func resetPosition() {
        location = origin
    }
        
    /// called internally whenever the location is updated
    /// returns the rect closest to the token
    private func activateNearestRect() {
        var nearestDistance: CGFloat = .infinity
        for (index,rect) in rects.enumerated() {
            let distanceToLocation = rect.center.squareDistance(to: location)
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
        
        // reset location if no activeIndex is set
        guard let index = activeIndex, index > 0, index < rects.count else { self.location = origin; return }
        
        self.location = location(for: index, and: rects[index])
                
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
    @ObservedObject var token : Token
    
    var body: some View {
        Circle()
            .frame(width: token.size, height: token.size)
            .opacity(0.8)
            .overlay(
                Text ("T")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            )
            .position(token.location)
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
