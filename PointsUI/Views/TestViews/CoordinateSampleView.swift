//
//  CoordinateSampleView.swift
//  PointsUI
//
//  Created by Alexander Völz on 05.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

class Settings : ObservableObject {
    @Published var position: CGPoint
    
    init() {
        position = .zero
    }
}

struct GlobalView: View {
    @ObservedObject var settings = Settings()
    
    var items : [ GridItem ] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: items, spacing: 50) {
                ForEach(0 ..< 4) { _ in
                    CoordinateSampleView()
                }
            }
            
            Ball()
        }
        .background(Color.gray)
        .gesture(drag)
        .environmentObject(settings)
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { info in
                settings.position = info.location
            }
    }

}

struct Ball: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Circle()
            .frame(width: 25, height: 25)
            .padding(5)
            .foregroundColor(.blue)
            .position(settings.position)
    }
}

struct CoordinateSampleView: View {
    
    var body: some View {
        Color.red.frame(width: 100, height: 100)
            .cornerRadius(27)
    }
}

struct CoordinateSampleView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView()
    }
}
