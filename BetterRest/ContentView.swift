//
//  ContentView.swift
//  BetterRest
//
//  Created by Shomil Singh on 06/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sleephours:Double=8
    var body: some View {
        Stepper("\(sleephours.formatted()) hours", value: $sleephours ,in: 1...24,step: 0.25)
            .padding()
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
