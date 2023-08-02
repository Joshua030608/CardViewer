//
//  ContentView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var folderStore: FolderStore
    @EnvironmentObject var navigationModel: NavigationModel
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                VStack {
                    Button {
                        navigationModel.navigationPath.append("Hello World")
                    } label: {
                        Text("Add to Path")
                    }

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
            }.navigationDestination(for: String.self) { string in
                Text(string)
            }
        }
    }
    init(folderStore: FolderStore) {
        self._folderStore = StateObject(wrappedValue: folderStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(folderStore: FolderStore())
    }
}
