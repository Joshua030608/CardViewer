//
//  CollectionView.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/23/23.
//

import SwiftUI


struct CardView: View {
    var card: Card
    @State var isShowingFront = true
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                CardInfoView(card: card)
            } label: {
                HStack {
                    VStack {
                        Text(card.playerName)
                        Text(card.team)
                        if card.playerName == "" {
                            Text("No name")
                                .font(.title2)
                        }
                    }
                    Spacer()
                    Text(card.position)
                    Spacer()
                    if let _ = card.frontImageData {
                        Image(uiImage: isShowingFront ? UIImage(data: card.frontImageData!)! : UIImage(data: card.backImageData!)!)
                            .resizable()
                            .frame(width: 150, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                withAnimation {
                                    isShowingFront.toggle()
                                }
                            }
                            .rotation3DEffect(.degrees(isShowingFront ? 0.0 : 180.0), axis: (x: 0, y: 1, z: 0))
                    } else {
                        Text("No images found!")
                            .font(.title3)
                    }
                }
            }
        }
    }
}

struct FolderView: View {
    
    let folderStore: FolderStore
    let folder: Folder
    
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
                
                NavigationLink(destination: CardAddEditView(folderStore: folderStore, folder: folder, card: nil)) {
                    Text("Add Card")
                        .font(.largeTitle)
                }
            }
        }
        /*.sheet(isPresented: $folderAddEditIsShowing, content: {
            VStack {
                TextField("Name", text: $newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding(50)
                Picker(selection: $newFolderLeague, label: Text("")) {
                    ForEach(League.allCases) { case1 in
                        Text(case1.rawValue)
                            .tag(case1)
                    }
                }
                Button {
                    print("Save button about to save, currently " + String(folderStore.folders.count) + " folders. New folder's name is " + newFolderName + " and its league is " + newFolderLeague.rawValue + ".")
                    //Save Folder with the old folder's id IF EDITING
                    folderStore.save(folder: Folder(name: newFolderName, cards: [], league: newFolderLeague))
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
        }) */
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
