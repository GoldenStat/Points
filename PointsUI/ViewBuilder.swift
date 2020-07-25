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
    var maxHeight: CGFloat
    var emphasizeColor: Color { theme == .dark ? .lightMidnight : .darkNoon }
    var content: Content
    init(theme: Theme = .dark,maxHeight: CGFloat = .infinity, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
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
    
    let cornerRadius: CGFloat = 4
    let blurRadius: CGFloat = 5
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 10.0, x: 8, y: 8)
}

struct EmphasizeCircle<Content: View> : View {
    var theme: Theme
    var maxHeight: CGFloat
    var emphasizeColor: Color { theme == .dark ? .lightMidnight : .darkNoon }
    var content: Content
    init(theme: Theme = .dark,maxHeight: CGFloat = .infinity, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
        Circle()
            .fill(emphasizeColor)
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
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 10.0, x: 8, y: 8)
}

struct EmphasizeShape<Content: View> : View {
    var theme: Theme
    var maxHeight: CGFloat
    var emphasizeColor: Color { theme == .dark ? .lightMidnight : .darkNoon }
    var content: Content
    init(theme: Theme = .dark,maxHeight: CGFloat = .infinity, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
        Clip(isInvisible: true) {
            content
        }
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
    let shadow : (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (color: Color.accentColor, radius: 10.0, x: 8, y: 8)
}
struct Clip<Content: View> : View {
    var isInvisible: Bool = false
    var content: Content
    var borderColor: Color
    var lineWidth : CGFloat
    var cornerRadius: CGFloat

    init(borderColor: Color = Color.blue, cornerRadius: CGFloat = 4, lineWidth: CGFloat = 4, isInvisible: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.isInvisible = isInvisible
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        content
            .background(Color.darkNoon)
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

extension View {
    func framedClip(borderColor: Color = Color.blue, cornerRadius: CGFloat = 4, lineWidth: CGFloat = 4, isInvisible: Bool = false) -> some View {
        Clip(borderColor: borderColor, cornerRadius: cornerRadius, lineWidth: lineWidth, isInvisible: isInvisible) {
            self
        }
    }
    
    func emphasize(theme: Theme = .light, maxHeight: CGFloat = 100) -> some View {
        Emphasize(theme: theme, maxHeight: maxHeight) {
            self
        }
    }
    func emphasizeShape(theme: Theme = .light, maxHeight: CGFloat = 100) -> some View {
        EmphasizeShape(theme: theme, maxHeight: maxHeight) {
            self
        }
    }

    func emphasizeCircle(theme: Theme = .light, maxHeight: CGFloat = 100) -> some View {
        EmphasizeCircle(theme: theme, maxHeight: maxHeight) {
            self
        }
    }
    
}
