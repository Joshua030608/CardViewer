//
//  ContentView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.red
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text("CardViewer")
                        .font(.largeTitle)
                    NavigationLink {
                        CollectionView()
                    } label: {
                        Text("Start")
                            .font(.largeTitle)
                            .background(Color.black)
                    }
                    .padding()
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
