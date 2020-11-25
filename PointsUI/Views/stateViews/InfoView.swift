//
//  InfoView.swift
//  PointsUI
//
//  Created by Alexander Völz on 03.07.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// a description on how the program works
struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let description = "Count your game points with this app."
    
    let paragraph = """
    You have several views: the one typically used for Truco which is lined boxes. But, in case you want to check in which round you made how many points, there are two other views available. Just swipe through the views.

    Double-clicking gets you into the menubar which has history options, so you can go back and forth in case you did make an error somewhen.

    Also, if you click on the little arrow on the top you get to set things like how long it takes to make the noted points permanent, the number of players - pretty limited in Truco - or the amount of points per game, as there are various variants (usually 24 or 30, but I made this configurable)

    Note that you loose tracking points for the game if you change the number of players.

    Please let me know if you have any suggestions, new rules you want to apply, etc.

    I am planning to add a 'new rule' option, so that you can design your own games.

"""
    
    var body: some View {
        VStack {
            Text(PointsUIApp.name)
                .font(.largeTitle)
            Text(description)
                .font(.subheadline)
            Spacer()
            Text(paragraph)
                .font(.body)
        }
        .padding()
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
