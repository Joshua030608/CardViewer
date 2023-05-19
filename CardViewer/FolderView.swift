//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI


struct CardView: View {
    var card: Card
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                CardInfoView(card: card)
            } label: {
                HStack {
                    VStack {
                        Text(card.playerName)
                        Text(card.team)
                    }
                    Spacer()
                    Text(card.position)
                    Spacer()
                    if let frontData = card.frontImageName {
                        Image(uiImage: UIImage(data: card.frontImageName!)!)
                            .resizable()
                            .frame(width: 150, height: 200)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("No images found!")
                            .font(.largeTitle)
                    }
                }
            }
        }
    }
}

struct FolderView: View {
    
    let folderStore: FolderStore
    
    @State private var folderAddEditIsShowing = false
    @State private var newFolderName = ""
    @State private var newFolderLeague: League = .NFL
    @State private var newFolderCards: [Card] = []
    
    private var cards: [Card] {
        if folderStore.folders.isEmpty {
            return []
        } else {
            return folderStore.folders.first!.cards
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    List {
                        ForEach(cards) { card in
                            CardView(card: card)
                        }
                    }
                    .opacity(cards.isEmpty ? 0.0 : 1.0)
                    Text("No Cards Have Been Added!")
                        .padding(125)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .opacity(cards.isEmpty ? 1.0 : 0.0)
                }
                Button {
                    folderAddEditIsShowing = true
                } label: {
                    Text("Add Folder")
                        .font(.largeTitle)
                }

            }
        }
        .sheet(isPresented: $folderAddEditIsShowing, content: {
            VStack {
                TextField("Name", text: $newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding(50)
                Picker(selection: $newFolderLeague, label: Text("")) {
                    ForEach(0..<4) { index in
                        if index == 0 {
                            Text(League.NFL.rawValue)
                                .tag(League.NFL)
                        } else if index == 1 {
                            Text(League.NBA.rawValue)
                                .tag(League.NBA)
                        } else if index == 2 {
                            Text(League.MLB.rawValue)
                                .tag(League.MLB)
                        } else if index == 3 {
                            Text(League.NHL.rawValue)
                                .tag(League.NHL)
                        }
                    }
                }
                Button {
                    print("Save button about to save, currently " + String(folderStore.folders.count) + " folders. New folder's name is " + newFolderName + " and its league is " + newFolderLeague.rawValue + ".")
                    //Save Folder with the old folder's id IF EDITING
                    folderStore.save(folder: Folder(name: newFolderName, cards: [/*idk*/], league: newFolderLeague))
                    print("Save Folder Button Pressed, there are now " + String(folderStore.folders.count) + " folders.")
                    folderAddEditIsShowing = false
                    newFolderName = ""
                    newFolderLeague = .NFL
                } label: {
                    Text("Save Folder")
                        .cornerRadius(10)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .background(.blue)
                }

            }
        })
        .toolbar(.hidden)
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
