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

    var size: CGFloat = 60
    
    private var origin: CGPoint = CGPoint(x: 100, y: 100)
    
    @Published var location: CGPoint = CGPoint(x: 80, y: 80)

    public func setup(with numberOfRects: Int) {
        rects = Array<CGRect>(repeating: CGRect(), count: numberOfRects)
    }

    @Published var activeIndex: Int? = nil 
    
    // there have to be more rects than max players
    @Published var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 8)
    
    /// if our calling view wants to do something with this information (e.g. highligt the area)
    public var activeFrame: CGRect? {
        if let index = activeIndex, index < rects.count, index > 0 {
            return rects[activeIndex!]            
        }
        return nil
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
    private func moveToActiveRect() {
        
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
    
    var size : CGFloat

    var animate : Bool = false
    var zoomFactor: CGFloat { animate ? 1.3 : 1.0 }
    
    struct ShadowModifier {
        var color: Color
        var radius: CGFloat
        var x: CGFloat
        var y: CGFloat

        static let up = ShadowModifier(color: .black, radius: 10, x: 8, y: 8)
        static let down = ShadowModifier(color: .black, radius: 4, x: 2, y: 2)
    }
    
    var shadow : ShadowModifier { animate ? .up : .down }
    var shadowColor: Color { animate ? .black : .clear }
    var rotationAngle: Angle { animate ? .degrees(30) : .zero }
    var tokenAnimation: Animation {
        animate ? .spring(response: 1, dampingFraction: 0.1, blendDuration: 0.3) : .default
    }
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .overlay(
                Text ("T")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            )
            .animation(nil)
            .rotation3DEffect(
                rotationAngle,
                axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            .animation(tokenAnimation)
            .scaleEffect(zoomFactor)
            .shadow(color: shadow.color,
                    radius: shadow.radius,
                    x: shadow.x, y: shadow.y)
            .animation(.default)
    }        
}


//extension VerticalAlignment {
//    private enum MarkerAlignment: AlignmentID {
//        static func defaultValue(in d: ViewDimensions) -> CGFloat {
//            return d[VerticalAlignment.center]
//        }
//    }
//
//    static let markerAlignment = VerticalAlignment(MarkerAlignment.self)
//}

struct AnchorBox: View {
    var index: Int
    var isActive: Bool = false
    
    var borderColor: Color { isActive ? .primary : .secondary }
    var body: some View {
        Color.green
            .cornerRadius(12)
            .opacity(isActive ? 0.8 : 0.4)
            .frame(width: 100, height: 200)
            .overlay(Text(index.description)
                        .font(.largeTitle)
                        .scaleEffect(isActive ? 1.3 : 1.0)
                        .foregroundColor(isActive ? .red : .white)
        )
    }
}

/// the marker shows who is "active", e.g. the dealer
struct TokenView: View {
    var size : CGFloat
    var color: Color = .primary
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}

// MARK: Anchor View
/// a preference anchor is also a preference value
struct AnchorView : View {
    @State private var activeIndex = 0
    @State var token = Token()

    /// holds all Player View's frames, determines max Players
    @State var rects = Array<CGRect>(repeating: CGRect(), count: 8)
    var activeFrame: CGRect  { rects[activeIndex] }
    
    var objectCount : Int { rects.count }
    
    let markerSize : CGFloat = 40
    let padding : CGFloat = 20
    
    var body: some View {
        
        ZStack() {
            
            VStack {
                ForEach(0 ..< PlayerGrid.rows) { row in
                    
                    HStack
                    {
                        ForEach(0 ..< PlayerGrid.cols) { col in
                            
                            let index = PlayerGrid(row: row, col: col).index
                            
                            if index < objectCount {
                                
                                /// used with preference Anchors
                                AnchorBox(
                                    
                                    /// details of each box
                                    index: index,
                                    isActive: index == activeIndex
                                )
                                .anchorPreference(key: TokenAnchorPreferenceKey.self,
                                                  value: .bounds,
                                                  transform: { bounds in
                                                    [TokenAnchor(viewIdx: index, bounds: bounds)]
                                })
                                
                                .onTapGesture {
                                    activeIndex = index
                                    withAnimation(.linear(duration: 0.3)) {
                                        updateTokenLocation()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        /// needed for preference Anchors
        .overlayPreferenceValue(TokenAnchorPreferenceKey.self) {
            preferences in
            GeometryReader { geometry in
                updateRects(geometry, preferences)
            }
        }
        .padding(.horizontal)
    }
    
    /// a pseudo - view to use its side effect to update the active Frame
    /// it exists, because GeometryReader's block is a ViewBuiler function
    func updateRects(_ geometry: GeometryProxy,
                     _ preferences: [TokenAnchor]) -> some View {

        rects = preferences.map { geometry[$0.bounds] }

        return TokenView(size: token.size)
            .position(token.location)
            .gesture(dragGesture) // important for the Geometry Proxy Dimensions
    }
    
    // MARK: handle token position
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged() { dragValue in
                token.location = dragValue.location
                updateActiveIndex()
            }
            .onEnded() { value in
                updateActiveIndex()
                withAnimation(.easeInOut(duration: 0.5)) {
                    updateTokenLocation()
                }
            }
    }
    
    /// called when the move gesture ends
    /// moves the token to the active Frame
    func updateTokenLocation() {
        
        token.location = tokenLocation(for: activeIndex)
        
        /// get token Location for a given index
        ///
        /// orientates itself on the Grid's tokenEdge method
        /// defaults to center of the frame
        func tokenLocation(for index: Int) -> CGPoint {
            
            let frame = rects[index]
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
    
    /// figure out nearest view to Token position
    func updateActiveIndex() {
        var nearestDistance: CGFloat = .infinity
        for (index,rect) in rects.enumerated() {
            let distanceToLocation = rect.center.squareDistance(to: token.location)
            if nearestDistance > distanceToLocation {
                nearestDistance = distanceToLocation
                activeIndex = index
            }
        }
    }
    
}

struct AnchorView_Previews: PreviewProvider {
    static var previews: some View {
//        AnchorView()
        ActivePlayerMarkerView(size: 60,
                               animate: true
        )
    }
}
