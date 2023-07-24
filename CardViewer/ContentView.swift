//
//  ContentView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    private let folderStore: FolderStore
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
                        FolderListView(folderStore: folderStore)
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
    init(folderStore: FolderStore) {
        self.folderStore = folderStore
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(folderStore: FolderStore())
    }
}
