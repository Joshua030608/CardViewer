//
//  CardInfoView.swift
//  CardViewer
//
//  Created by Joshua Ford on 5/8/23.
//

import SwiftUI

struct CardInfoView: View {
    
    let card: Card
    @State var moveToCardAddEditView = false
    @EnvironmentObject var folderStore: FolderStore
    
    var body: some View {
        VStack {
            HStack {
                if let frontData = card.frontImageName {
                    Image(uiImage: UIImage(data: frontData)!)
                        .resizable()
                        .frame(width: 150, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
                if let backData = card.backImageName {
                    Image(uiImage: UIImage(data: backData)!)
                        .resizable()
                        .frame(width: 180, height: 300)
                        .aspectRatio(contentMode: .fit)
                }
            }
                Text(card.playerName)
                    .font(Font(CTFont(.system, size: 30)))
            Text(card.position)
                .font(.title2)
            Text(card.team)
                .font(.title2)
            Text("Number of folders: " + String(folderStore.folders.count))
            if card.playerName == nil || card.playerName == "" {
                Text("No player name given")
                    .font(Font(CTFont(.system, size: 30)))
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Edit Button Pressed for Player: " + card.playerName)
                    moveToCardAddEditView = true
                } label: {
                    Text("Edit")
                }
            }
        }
        NavigationLink(
            destination:
                CardAddEditView(
                    folderStore: folderStore,
                    folder: folderStore.folders.first!,
                    card: card
                ),
               isActive: $moveToCardAddEditView
        ) {
            EmptyView()
        }
    }
}
