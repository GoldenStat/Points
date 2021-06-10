//
//  ScrollScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 21.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI


/// show Score
///
/// * TAP: toggle between scroll mode (add buffer) and showing score
///
/// * scrolling shows the points that will be added (the buffer)
///
/// * as an overlay you see the score that will result in
///
/// * when you exit scroll mode, the buffer is set to the selected score and the timer is started
///
struct ScrollScoreView: View {
    
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var player: Player
    
    var score: Score { player.score }
        
    @State var pickerSelected = false
        
    @State var bufferScore = 0
    
    var body: some View {
        Group {
            if pickerSelected {
                CustomScoreWheelPicker(selected: $bufferScore)
            } else {
                ScalingTextView(score.value.description)
            }
        }
        .frame(width: 200)
        .overlay(ScalingTextView(bufferText)
                    .foregroundColor(bufferColor)
                    .frame(width: 100, height: 100)
                 ,alignment: .topTrailing)
        .foregroundColor(.points)
        .background(Color.background)
        .onTapGesture() {
            withAnimation() {
                if pickerSelected {
                    // if the picker was selected, add the selected value
                    player.add(score: bufferScore)
                    settings.startTimer()
                } else {
                    // if not, reset the buffer and the timer
                    settings.cancelTimers()
                    bufferScore = 0
                }
                pickerSelected.toggle()
            }
        }
        // with this the tap gesture doesn't work
//        .onReceive([$settings.registerRoundTimer].publisher, perform: { _ in
//            pickerSelected = false
//        })

    }
    
    var bufferText: String {
        if pickerSelected {
            return score.sum.description
        } else {
            return score.buffer.description
        }
    }
    
    var bufferColor : Color {
        if pickerSelected {
            return .pointbuffer
        } else {
            if score.buffer == 0 {
                return .clear
            } else {
                return .blue
            }
        }
    }
}

// MARK: custom picker declaration

/// The picker to select the buffer you want to add to the points
struct CustomScoreWheelPicker : UIViewRepresentable {
    
    /// the binding to the value that will be modified by the picker
    @Binding var selected: Int
    
    /// <#Description#>
    /// - Returns: <#description#>
    func makeCoordinator() -> Coordinator {
        CustomScoreWheelPicker.Coordinator(parent: self, value: selected)
    }
    
    /// <#Description#>
    /// - Parameter context: <#context description#>
    /// - Returns: <#description#>
    func makeUIView(context: UIViewRepresentableContext<CustomScoreWheelPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomScoreWheelPicker>) {
        
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: CustomScoreWheelPicker
        var value: Int
        private var data : [Int] { Array(value ...  value + 50) }
        let stepRange = 50

        init(parent: CustomScoreWheelPicker, value: Int) {
            self.parent = parent
            self.value = value
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            data.count
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selected = data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 120))
            
            view.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = String(data[row])
            
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 128, weight: .bold)

            view.addSubview(label)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height / 2
            
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.blue.cgColor
            
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 120
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 260
        }
        

    }
}


struct ScoreWheelTest: View {
    @State private var buffer : Int = 0
    @State private var points = 0
    
    var score: Score { Score(points, buffer: buffer) }
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score.value)")
                Text("Buffer: \(score.buffer)")
            }
            .font(.title)

            CustomScoreWheelPicker(selected: $buffer)
                .frame(width: 200, height: 300)

        }
        .animation(.easeInOut)
    }
}

struct ScrollScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollScoreView()
//            ScoreWheelTest()
            .environmentObject(GameSettings())
            .environmentObject(Player(name: "Alex"))
            .frame(width: 200, height: 300)
            .previewLayout(.sizeThatFits)
    }
}
