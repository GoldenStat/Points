//
//  GeoEffectTest.swift
//  PointsUI
//
//  Created by Alexander Völz on 04.02.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI

struct GeoEffectTest: View {
    @State var show = false
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if !show {
                VStack {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 10)
                            .matchedGeometryEffect(id: "cover", in: namespace)
                            .frame(width: 40)
                        Text("Fever")
                            .matchedGeometryEffect(id: "title", in: namespace)
                        Spacer()
                        Image(systemName: "play.fill")
                            .matchedGeometryEffect(id: "play", in: namespace)
                            .font(.title)
                        Image(systemName: "forward.fill")
                            .matchedGeometryEffect(id: "forward", in: namespace)
                            .font(.title)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.pointsTop)
                    .matchedGeometryEffect(id: "background", in: namespace)
                )
            } else {
                VStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 30)
                        .matchedGeometryEffect(id: "cover", in: namespace)
                        .frame(height: 300)
                        .padding()
                    Text("Fever")
                        .matchedGeometryEffect(id: "title", in: namespace)
                    Spacer()
                    Image(systemName: "play.fill")
                        .matchedGeometryEffect(id: "play", in: namespace)
                        .font(.title)
                    Image(systemName: "forward.fill")
                        .matchedGeometryEffect(id: "forward", in: namespace)
                        .font(.title)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.pointsTop)
                    .matchedGeometryEffect(id: "background", in: namespace)
                )
            }
        }
        .foregroundColor(.white)
        .onTapGesture {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
}

struct GeoEffectTest_Previews: PreviewProvider {
    static var previews: some View {
        GeoEffectTest()
    }
}
