//
//  ContentView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                Text("CardViewer")
                Button {
                    print("Start Pressed")
                } label: {
                    Color.green
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
