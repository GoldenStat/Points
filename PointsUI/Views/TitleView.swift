//
//  Title.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var settings: GameSettings
    @State private var animatedState = Params.initial

    var body: some View {
        ZStack {
            Color.background
            Text(PointsUIApp.name)
                
                .font(.system(size: animatedState.fontSize))
                .rotationEffect(.degrees(animatedState.textAngle),
                                anchor: .center)
                .offset(animatedState.offset)
                .scaleEffect(animatedState.textZoom)
                .opacity(animatedState.opacity)
                .foregroundColor(animatedState.color)
                .animation(animatedState.spring)
                .onAppear {
                    animatedState = Params.appear
                }
        }
        .onTapGesture {
            animatedState = Params.background
        }
    }
        
    // MARK: - Defining constant parameters used for animating states
    private struct Params {
        
        let spring: Animation
        let offset: CGSize
        let fontSize: CGFloat
        let textAngle: Double
        let textZoom: CGFloat
        let color: Color
        let opacity: Double
        
        public static let initial = Params(spring: Animation.spring(response: 1.0, dampingFraction: 0.0, blendDuration: 1.0),
                                            offset: CGSize(width: 0.0, height: -200),
                                            fontSize: 134,
                                            textAngle: 0,
                                            textZoom: 0,
                                            color: Color.primary,
                                            opacity: 1.0)
        
        public static let appear = Params(spring: Animation.spring(response: 2.0, dampingFraction: 0.6, blendDuration: 1.0),
                                           offset: CGSize(width: 0.0, height: 0),
                                           fontSize: 134,
                                           textAngle: 0,
                                           textZoom: 1.0,
                                           color: Color.points,
                                           opacity: 0.6)
        
        public static let background = Params(spring: Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.4),
                                               offset: CGSize(width: 0.0, height: 0),
                                               fontSize: 134,
                                               textAngle: 45,
                                               textZoom: 1.6,
                                               color: Color.pointbuffer,
                                               opacity: 0.1)
    }
}

struct Background: View {
    
    var body: some View {
        ZStack {
            Color.boardbgColor
                .edgesIgnoringSafeArea(.all)
            TitleView()
        }
    }
}


struct Background_Previews: PreviewProvider {
    
    static var previews: some View {
        Background()
    }
}
