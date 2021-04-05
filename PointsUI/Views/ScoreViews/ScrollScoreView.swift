//
//  ScrollScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 21.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI


/// show Score
/// tap: enter scroll mode
/// scroll mode: show points above and below (score + buffer) like a one-armed bandit show just buffer as (+-buffer) in small upper left
/// scroll up or down
/// start timer, when it fires, register points
/// new tap: register points

struct ScrollScoreView: View {
    
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var player: Player
    
    var score: Score { player.score }
    var step : Int { settings.rule.scoreStep.defaultValue }
    
    private var isSelectingScore : Bool {
        settings.timerPointsStarted && score.buffer != 0
    }
    
    var bufferDescription : String {
        score.buffer > 0 ? "+\(score.buffer)" : "\(score.buffer)"
    }
    
    @State var scrollingSpeed: CGFloat = 100
    
    var body: some View {
        Group {
            if isSelectingScore {
                scoreWheel
                    .frame(width: 200)
                    .overlay(ScalingTextView(bufferDescription)
                                .foregroundColor(bufferColor)
                                .scaleEffect(0.4)
                                .offset(x: 30, y: -100))
            } else {
                ScalingTextView(score.value.description)
            }
        }
        .onTapGesture {
            withAnimation() {
                player.saveScore() // sets the buffer to 0 -> isSelected = false
            }
        }
        .foregroundColor(.points)
        .background(Color.background)
        .highPriorityGesture(moveGesture)
    }
        
    // MARK: - supporting views and gestures
    
    @GestureState var movement: DragGesture.Value?
    
    var scoreDidChange : Bool { movement != nil }

    /// on Drag this function will be called
    /// changes the buffer Value and starts the timer when movement ended
    /// uses projection value
    var moveGesture : some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($movement) { value, movement, transaction in
                guard !scoreDidChange else { return }
                withAnimation(.easeInOut(duration: 1.0)) {
                    handleDrag(from: value.startLocation, to: value.location)
                }
            }
            .onEnded() { _ in
                settings.startTimer()
            }
    }

    func handleDrag(from start: CGPoint, to end: CGPoint) {
        
        // stepLength: movement in points
        // three options : 1,5,10
        let steps : [CGFloat] = [100, 200, 300]

        var stepLength: CGFloat {
            guard let movement = movement else { return .zero }
            return movement.translation.height
        }
        
        
        
        let direction = start.y < end.y ? -1 : 1
        
        if abs(stepLength) > steps[2] {
            addPoints(direction * 10)
        } else if abs(stepLength) > steps[1] {
            addPoints(direction * 5)
        } else {
            addPoints(direction)
        }
            
    }
    
    func addPoints(_ points: Int) {
        player.add(score: points)
    }

    /// the current seletction is shown as kind of a picker, with numbers diminishing up or down
    var scoreWheel: some View {
        VStack(spacing: 10) {
            ForEach(scoreNumbers, id: \.self) { num in
                Text(num.description)
                    .scaleEffect(zoomFactor(for: num))
            }
        }
    }

    /// calculate a zoom factor for numbers further away from score
    /// uses linear interpolation
    func zoomFactor(for num: Int) -> CGFloat {
        guard score.sum != minNum, score.sum != -maxNum else { return CGFloat(minZoom) }
        let distFromScore = Double(abs(score.sum - num))
        
        // 0 < distFactor < 1
        let distFactor = distFromScore / Double(score.sum - minNum)
        
        return CGFloat(minZoom * distFactor + maxZoom * ( 1 - distFactor ))
    }
    
    /// all visible options during selection
    /// NOTE: assuming stride (scoreStep) of 1!
    var scoreNumbers: [Int] { [Int](minNum ... maxNum) }
    
    var minNum : Int { score.sum - visibleSteps }
    var maxNum : Int { score.sum + visibleSteps }
        
    // MARK: - constants
    let visibleSteps = 3
    let minZoom = 0.6
    let minOpacity = 0.2
    let maxZoom = 1.8
    
    let zoomingOpacity = 0.8
    let bufferColor = Color.pointbuffer
}

struct ScoreWheel: View {
    @Binding var score: Score
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)

            VStack(spacing: 10) {
                ForEach(scoreNumbers, id: \.self) { num in
                    Text(num.description)
                        .font(.title)
                        .scaleEffect(zoomFactor(for: num))
                }
            }
            
            if let movement = movement {
                Circle()
                    .strokeBorder(Color.black)
                    .background(Color.clear)
                    .position(movement.startLocation)
                    .frame(width: 20, height: 20)
                                
                Circle()
                    .position(movement.location)
                    .background(Color.clear)
                    .frame(width: 20, height: 20)
            }
            
            if stepLength != .zero {
                HStack {
                    Text("".appendingFormat("%d",stepLength))
                    ZStack {
                    Rectangle()
                        .fill(barColor)
                        .frame(width: 5, height: stepLength)
                        .offset(x: 0, y: -stepLength / 2)
                        // first marker at 0
                    Rectangle()
                        .frame(width: 10, height: 1)
                        .offset(x: -2.5, y: -steps[0])
                        // second marker at 50
                    Rectangle()
                        .frame(width: 10, height: 1)
                        .offset(x: -2.5, y: -steps[1])
                        // third marker at 100
                    Rectangle()
                        .frame(width: 10, height: 1)
                        .offset(x: -2.5, y: -steps[2])
                    }
                }
                .offset(x: 150)
            }
        }
        .gesture(moveGesture)
        .onTapGesture {
            score.add(points: 1)
        }
        .onTapGesture(count: 2) {
            score.add(points: -1)
        }
    }
    
    var barColor : Color { switch abs(stepLength) {
    case steps[0]..<steps[1]:
        return .yellow
    case steps[1]..<steps[2]:
        return .green
    case steps[2]...:
        return .red
    default:
        return .black
    }
    }
    
    let steps : [CGFloat] = [0, 100, 200]

    var stepLength: CGFloat {
        guard let movement = movement else { return .zero }
        return movement.translation.height
    }
    
    @GestureState var movement: DragGesture.Value?

    @State var count = 0
    
    var moveGesture : some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($movement) { value, movement, transaction in
                guard count < 5 else { return }
                movement = value
                // stepLength: movement in points
                // three options : 1,5,10
                if abs(stepLength) > steps[0] {
                    let direction = value.startLocation.y < value.location.y ? 1 : -1
                    var value = 1
                    if abs(stepLength) > steps[1] {
                        value = 5
                        if abs(stepLength) > steps[2] {
                            value = 10
                        }
                    }
                    withAnimation(.easeInOut(duration: 1.0)) {
                        score.add(points: direction * value)
                    }
                }
                count += 1
            }
            .onEnded() { _ in
                count = 0
            }
    }

    /// calculate a zoom factor for numbers further away from score
    /// uses linear interpolation
    func zoomFactor(for num: Int) -> CGFloat {
        guard score.sum != minNum, score.sum != -maxNum else { return CGFloat(minZoom) }
        let distFromScore = Double(abs(score.sum - num))
        
        // 0 < distFactor < 1
        let distFactor = distFromScore / Double(score.sum - minNum)
        
        return CGFloat(minZoom * distFactor + maxZoom * ( 1 - distFactor ))
    }
    
    /// all visible options during selection
    /// NOTE: assuming stride (scoreStep) of 1!
    var scoreNumbers: [Int] { [Int](minNum ... maxNum) }
    
    var minNum : Int { score.sum - totalSteps }
    var maxNum : Int { score.sum + totalSteps }
        
    // MARK: - constants
    let totalSteps = 10
    let visibleSteps = 3
    let minZoom = 0.6
    let minOpacity = 0.2
    let maxZoom = 1.8
    
    let zoomingOpacity = 0.8
    let bufferColor = Color.pointbuffer
}

struct ScoreWheelTest: View {
    @State private var score = Score()
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score.value)")
                Text("Buffer: \(score.buffer)")
            }
            .font(.title)
            HStack {
                ScoreWheel(score: $score)
                    .frame(width: 200, height: 300)
                VStack(spacing: 8) {
                    Button() {
                        score.add(points: 10)
                    } label: {
                        Image(systemName: "car.circle")
                    }
                    Button() {
                        score.add(points: 5)
                    } label: {
                        Image(systemName: "arrow.up.circle")
                    }
                    Button() {
                        score.add(points: 1)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    Button() {
                        score.add(points: -1)
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                }
                .font(.largeTitle)


            }
            Button("Save") {
                score.save()
            }
            .font(.title)
        }
        .animation(.easeInOut)
    }
}

struct ScrollScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreWheelTest()
//            .frame(width: 200, height: 300)
//            .previewLayout(.sizeThatFits)
    }
}
