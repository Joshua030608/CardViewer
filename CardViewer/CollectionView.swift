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
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(folderStore.folders.first!.cards) { card in
                        CardView(card: card)
                    }
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
