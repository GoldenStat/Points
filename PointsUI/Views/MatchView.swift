//
//  MatchView.swift
//  PointsUI
//
//  Created by Alexander Völz on 07.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MatchView: View {
    let bodyColor = Color.yellow
    let headColor = Color.red

    var body: some View {
        ZStack {
            MatchBodyShape()
                .fill(bodyColor)
            MatchHeadShape()
                .fill(headColor)
        }
    }
    
    static let matchRatio : CGSize = CGSize(width: 0.2,
                                                height: 1.0)
}

struct MatchHeadShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let centerX = rect.minX + rect.width / 2
        
        let circleRadius : CGFloat = rect.width * MatchView.matchRatio.width
        
        let circleCenter = CGPoint(x: centerX,
                                   y: -circleRadius)
        
        let flatSide = Angle(degrees: 90)
        let flatWidthHalf = Angle(degrees: 30)
        
        path.addArc(center: circleCenter, radius: circleRadius,
                    startAngle: flatSide - flatWidthHalf,
                    endAngle: flatSide + flatWidthHalf,
                    clockwise: true)
        path.closeSubpath()
        
        return path
    }
    
}

struct MatchBodyShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let centerX = rect.minX + rect.width / 2
        let size = CGSize(width: rect.width * MatchView.matchRatio.width,
                          height: rect.height
        )
        
        let matchBodyRect = CGRect(x: centerX - size.width / 2,
                                   y: rect.minY,
                                   width: size.width,
                                   height: size.height)
        
        path.addRect(matchBodyRect)
        
        return path
    }
    
}


struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
            .opacity(0.6)
            .frame(width: 100, height: 200)
            .environmentObject(GameSettings())
    }
}
