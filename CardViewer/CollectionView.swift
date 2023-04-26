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
        HStack {
            VStack {
                Text(card.playerName)
                Text(card.team)
            }
            Spacer()
            Text(card.position)
            Spacer()
            Image(uiImage: UIImage(data: card.frontImageName!)!)
                .resizable()
                .frame(width: 150, height: 200)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct CollectionView: View {
    
    let folderStore: FolderStore
    
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
                NavigationLink("Go", destination: CardAddEditView())
            }
        }
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
