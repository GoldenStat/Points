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
    var size : CGFloat
    var body: some View {
        Circle()
            .frame(width: size, height: size)
    }
}

struct PlayerBox: View {
    var name: String
    var isActive: Bool = false
    var borderColor: Color { isActive ? .primary : .secondary }
    var body: some View {
        Color.green
            .cornerRadius(20)
            .opacity(isActive ? 0.8 : 0.4)
            .frame(width: 100, height: 200)
            .overlay(Text(name)
                        .font(.largeTitle)
                        .scaleEffect(isActive ? 1.3 : 1.0)
                        .foregroundColor(isActive ? .red : .white)
        )
    }
}

/// to make the code a little clearer
///
/// GridIndex(0,0).index == 1
///
/// GridIndex.rows == 2, GridIndex.cols == 2 means a 2x2-Grid

struct GridIndex {
    static let rows = 2
    static let cols = 3
    
    /// how many objects the Grid can hold
    static var maxObject: Int { rows * cols }
    
    var row: Int
    var col: Int
    
    /// calculated index for this row and column
    var index: Int {
        get {
            row * Self.cols + col + 1
        }
        
        // not really needed in this example, but since we are already at it...
        set {
            let adjustedIndex = newValue - 1
            self.row = adjustedIndex / Self.cols
            self.col = adjustedIndex % Self.cols
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

extension HorizontalAlignment {
    private enum MarkerAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[HorizontalAlignment.center]
        }
    }
    
    static let markerAlignment = HorizontalAlignment(MarkerAlignment.self)
}

extension Alignment {
    static let markerAlignment = Alignment(horizontal: .markerAlignment, vertical: .markerAlignment)
}

struct GameView: View {
    @State private var activeIndex = 1
    
    let objectCount = 5 // must be smaller than GridIndex.maxObjects

    let markerSize : CGFloat = 80
        
    var body: some View {
        ZStack(alignment: .markerAlignment) {
            VStack {
                ForEach(0 ..< GridIndex.rows) { row in
                    HStack
                    {
                        ForEach(0 ..< GridIndex.cols) { col in
                            let count = GridIndex(row: row, col: col)
                            if objectCount >= count.index {
                                if count.index == activeIndex {
                                    PlayerBox(name: count.index.description, isActive: true)
                                        .transition(AnyTransition.identity)
                                        .alignmentGuide(HorizontalAlignment.markerAlignment, computeValue: { dimension in
                                            dimension[AlignmentObject.alignment(for: activeIndex).playerAlignment.horizontal]
                                        })
                                        .alignmentGuide(VerticalAlignment.markerAlignment, computeValue: { dimension in
                                            dimension[AlignmentObject.alignment(for: activeIndex).playerAlignment.vertical]
                                        })
                                        .onTapGesture {
                                                activeIndex = count.index
                                        }
                                } else {
                                    PlayerBox(name: count.index.description, isActive: false)
                                        .onTapGesture {
                                            activeIndex = count.index
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .padding(markerSize)
            
            ActivePlayerMarkerView(size: markerSize)
                .transition(AnyTransition.identity)
                .alignmentGuide(HorizontalAlignment.markerAlignment, computeValue: { dimension in
                    dimension[AlignmentObject.alignment(for: activeIndex).markerAlignment.horizontal]
                })
                .alignmentGuide(VerticalAlignment.markerAlignment, computeValue: { dimension in
                    dimension[AlignmentObject.alignment(for: activeIndex).markerAlignment.vertical]
                })
        }
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

    }
    
    /// hard-coded alignments for indices, wrapped into an object
    struct AlignmentObject {
        var markerAlignment: Alignment
        var playerAlignment: Alignment
        
        static func alignment(for index: Int) -> AlignmentObject {
            switch index {
            case 1:
                return AlignmentObject(markerAlignment: .center,
                                       playerAlignment: .topLeading)
            case 2:
                return AlignmentObject(markerAlignment: .bottom,
                                       playerAlignment: .top)
            case 3:
                return AlignmentObject(markerAlignment: .center,
                                       playerAlignment: .topTrailing)
            case 4:
                return AlignmentObject(markerAlignment: .topTrailing,
                                       playerAlignment: .bottomLeading)
            case 5:
                return AlignmentObject(markerAlignment: .topLeading,
                                       playerAlignment: .bottomTrailing)
            default:
                return AlignmentObject(markerAlignment: .center,
                                       playerAlignment: .center)
            }
        }
    }
    
}


struct ActivePlayerMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
