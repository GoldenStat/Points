//
//  ViewBuilder.swift
//  HHunter
//
//  Created by Alexander Völz on 02.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import Foundation

import SwiftUI

enum Theme { case dark, light }

extension Color {
    static let darkNoon = Color(red: 220/255, green: 220/255, blue: 255/255)
    static let lightMidnight = Color(red: 25/255, green: 25/255, blue: 0/255 )
}

/// a viewbuilder that emphasizes a view
/// in this context it tries to make put a mnemonic(?) frame around it
struct Emphasize<Content: View> : View {
    var theme: Theme
    var emphasizeColor: Color { theme == .dark ? .lightMidnight : .darkNoon }
    var content: Content
    init(theme: Theme = .dark, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(emphasizeColor)
                .clipped()
                .frame(maxHeight: maxHeight)
                .blur(radius: blurRadius)
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
                .overlay(
                    content
            )
        }
    }
    
    let cornerRadius: CGFloat = 4
    let maxHeight: CGFloat = .infinity
    let blurRadius: CGFloat = 5
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 10.0, x: 8, y: 8)
}

struct Frame<Content: View> : View {
    var isInvisible: Bool = false
    var content: Content
    
    init(@ViewBuilder content: () -> Content, isInvisible: Bool = false) {
        self.content = content()
        self.isInvisible = isInvisible
    }
    var body: some View {
        content
            .clipShape(
                clipShape()
        )
            .overlay(
                clipShape()
                    .stroke(strokeColor, lineWidth: border)
        )
    }
    
    var strokeColor: Color { isInvisible ? Color.clear : Color.blue }
    let radius : CGFloat = 10
    let border : CGFloat = 4

    func clipShape() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius)
    }
}

struct Clip<Content: View> : View {
    var framed: Bool = false
    var content: Content
    
    init(@ViewBuilder content: () -> Content, framed: Bool = false) {
        self.content = content()
        self.framed = framed
    }
    var body: some View {
        content
            .clipShape(
                clipShape()
        )
            .overlay(
                clipShape()
                    .stroke(strokeColor, lineWidth: border)
        )
    }
    
    var strokeColor: Color { framed ? Color.blue : Color.clear }
    let radius : CGFloat = 4
    let border : CGFloat = 4

    func clipShape() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius)
    }
}