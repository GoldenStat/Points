//
//  TransitionView.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.08.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TransitionView: View {
    
    @State var index = 2
    @State var translation : Double = 0
    
    var body: some View {
        selectView(for: index)
            .frame(width: 400, height: 400)
            .gesture(DragGesture()
                        .onChanged() {
                            value in
                            translation = Double(value.translation.width)
                        }
            )
    }
    
    var main : Bundling {
        Bundling(zoom: 1.0,
                 position: CGPoint(x: 0*translation, y: 0),
                 rotation: translation)
    }
    
    var left : Bundling {
        Bundling(zoom: 1.0,
                 position: CGPoint(x: -translation, y: 0),
                 rotation: translation - 90)
    }
    
    var right : Bundling {
        Bundling(zoom: 1.0,
                 position: CGPoint(x: translation, y: 0),
                 rotation: translation + 90)
    }
    
    struct Bundling {
        var zoom: Double
        var position: CGPoint
        var rotation: Double
    }
    
    func selectView(for index: Int) -> some View {
        return HStack {
            view1
                .rotation3DEffect(
                    .degrees(left.rotation),
                    axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .scaleEffect(left.zoom)
                .offset(left.position)
            
            view2
                .rotation3DEffect(
                    .degrees(main.rotation),
                    axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .scaleEffect(left.zoom)
                .offset(left.position)
            
            view3
                .rotation3DEffect(
                    .degrees(right.rotation),
                    axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                    anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                    anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                .scaleEffect(right.zoom)
                .offset(right.position)
        }
    }
    
    var view1: some View {
        RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .fill(Color.blue)
            .opacity(0.5)
            .overlay(Text("One"))
    }
    var view2: some View {
        RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .fill(Color.red)
            .opacity(0.5)
            .overlay(Text("Two"))
    }
    var view3: some View {
        RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .fill(Color.yellow)
            .opacity(0.5)
            .overlay(Text("Three"))
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
