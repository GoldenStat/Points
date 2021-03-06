//
//  ViewBuilder.swift
//  HHunter
//
//  Created by Alexander Völz on 02.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a viewbuilder that emphasizes a view
/// in this context it tries to make put a mnemonic(?) frame around it
struct Emphasize<Content: View> : View {
    var maxHeight: CGFloat
    var content: Content
    init(maxHeight: CGFloat = .infinity, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.background)
            .clipped()
            .frame(maxHeight: maxHeight)
            .blur(radius: blurRadius)
            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
            .overlay(
                content
            )
    }
    
    let cornerRadius: CGFloat = 4
    let blurRadius: CGFloat = 5
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 14.0, x: 6, y: 6)
}

struct EmphasizeCircle<Content: View> : View {
    var maxHeight: CGFloat
    var content: Content
    init(maxHeight: CGFloat = .infinity, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
        Circle()
            .fill(Color.background)
            .clipped()
            .frame(maxHeight: 40)
            .blur(radius: 3)
            .shadow(color: shadow.color,
                    radius: shadow.radius,
                    x: shadow.x,
                    y: shadow.y)
            .overlay(
                content
            )
    }
    
    let cornerRadius: CGFloat = 4
    let blurRadius: CGFloat = 5
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.points, radius: 2.0, x: 0, y: 0)
}

struct EmphasizeShape<Content: View> : View {
    var maxHeight: CGFloat
    var content: Content
    var cornerRadius: CGFloat
    var isInvisible: Bool

    init(maxHeight: CGFloat = .infinity, cornerRadius: CGFloat = 4, isInvisible: Bool = false, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.content = content()
        self.cornerRadius = cornerRadius
        self.isInvisible = isInvisible
    }


    var body: some View {
        Clip(cornerRadius: cornerRadius, isInvisible: isInvisible) {
            content
        }
        .blur(radius: blurRadius)
        .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        .overlay(
            Clip(cornerRadius: cornerRadius, isInvisible: true) {
                content
            }
        )
    }
    
    let blurRadius: CGFloat = 5
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 10.0, x: 8, y: 8)
}

struct Clip<Content: View> : View {
    var isInvisible: Bool = false
    var cornerRadius: CGFloat
    var content: Content
    var borderColor: Color
    var lineWidth : CGFloat

    init(borderColor: Color = Color.blue, cornerRadius: CGFloat = 4, lineWidth: CGFloat = 4, isInvisible: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.isInvisible = isInvisible
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        content
            .background(Color.background)
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
    
    var strokeColor: Color { isInvisible ? Color.clear : borderColor }
}

fileprivate struct EmbedInStack: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    func body(content: Content) -> some View {
        Group {
            if sizeCategory > ContentSizeCategory.medium {
                VStack { content }
            } else {
                HStack { content }
            }
        }
    }
}

extension Group where Content: View {
    func embedInStack() -> some View {
        modifier(EmbedInStack())
    }
}

extension View {
    func framedClip(borderColor: Color = Color.blue, cornerRadius: CGFloat = 4, lineWidth: CGFloat = 4, isInvisible: Bool = false) -> some View {
        Clip(borderColor: borderColor, cornerRadius: cornerRadius, lineWidth: lineWidth, isInvisible: isInvisible) {
            self
        }
    }
    
    func emphasize(maxHeight: CGFloat = .infinity) -> some View {
        Emphasize(maxHeight: maxHeight) {
            self
        }
    }
    
    func emphasizeShape(cornerRadius: CGFloat = 4.0, isInvisible: Bool = false) -> some View {
        EmphasizeShape(cornerRadius: cornerRadius, isInvisible: isInvisible) {
            self
        }
    }

    func emphasizeCircle(maxHeight: CGFloat = 100) -> some View {
        EmphasizeCircle(maxHeight: maxHeight) {
            self
        }
    }
    
}
