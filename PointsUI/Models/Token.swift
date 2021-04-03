//
//  Token.swift
//  PointsUI
//
//  Created by Alexander Völz on 02.04.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

enum TokenState {
    case active // token is used normally, aligns to player's views
    case inactive // token is hidden in menu
    case free // token is active, but moves around freely
    
    mutating func toggle() {
        switch self {
        case .active:
            self = .free
        case .free:
            self = .inactive
        case .inactive:
            self = .active
        }
    }
}

/// Main components of the token are it's original position, a manipulatatble
///
/// change the activeIndex (index of the referring rect) -> the lastPosition is updated regarding on the geometry of this rect. Delta is reset
/// calling updateLocation() -> the nearest center of the rects is found, and lastPosition is updated in reference to that rect
///
class Token : ObservableObject {

    var size: CGFloat = 60
    
    private var origin: CGPoint = CGPoint(x: 100, y: 0)
    
    @Published var location: CGPoint = CGPoint(x: 80, y: 80) {
        didSet {
            objectWillChange.send()
        }
    }
    
    var state : TokenState = .inactive { didSet {
        if state == .inactive {
            resetPosition()
        }
    }}
    
    func toggleState() {
        
        state.toggle()
                
    }

    public func setup(with numberOfRects: Int) {
        rects = Array<CGRect>(repeating: CGRect(), count: numberOfRects)
    }

    @Published var activeIndex: Int? = nil
    
    // there have to be more rects than max players
    private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 8)
        
    /// if our calling view wants to do something with this information (e.g. highligt the area)
    public var activeFrame: CGRect? {
        if let index = activeIndex, index < rects.count, index > 0 {
            return rects[activeIndex!]
        }
        return nil
    }
                
    /// called if the referencing rect's bounds change
    public func update(bounds: [CGRect]) {
        self.rects = bounds
    }

    /// go back to original location (e.g. if the game restarts / no player got activated)
    public func resetPosition() {
        location = origin
    }
        
    /// called internally whenever the location is updated
    /// returns the rect closest to the token
    public func findIndexOfNearestRect() -> Int? {
        var nearestDistance: CGFloat = .infinity
        var nearestIndex: Int? = nil
        for (index,rect) in rects.enumerated() {
            let distanceToLocation = rect.center.squareDistance(to: location)
            if nearestDistance > distanceToLocation {
                nearestDistance = distanceToLocation
                nearestIndex = index
            }
        }
        return nearestIndex
    }

    /// called when the move gesture ends
    /// moves the token to the active Frame
    /// needed if token Index Is set
    public func moveToActiveRect() {
        
        // don't move unless state is .active (as opposed to .inactive or .free)
        
        guard state == .active else {
            return
        }
        
        // reset location if no activeIndex is set
        guard let index = activeIndex, index >= 0, index < rects.count else { self.location = origin; return }
        
        self.location = location(for: index, and: rects[index])
                
        /// get token Location for a given index
        ///
        /// orientates itself on the Grid's tokenEdge method
        /// defaults to center of the frame


        func location(for index: Int, and frame: CGRect ) -> CGPoint {
            var padding : CGFloat { size / 2 }

            let item = PlayerGrid(index: index)
            let distanceFromEdge = padding
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
                // don't change
                return self.location
            }
            
            /// don't move if distance is too big
            if newTokenLocation.squareDistance(to: self.location) > 100 {
                return self.location
            }
            
            return newTokenLocation
        }
        
    }
}
