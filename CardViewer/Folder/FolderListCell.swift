//
//  FolderListCell.swift
//  CardViewer
//
//  Created by Joshua Ford on 8/22/23.
//

import SwiftUI

struct FolderListCell: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let folder: Folder
    
    var body: some View {
        HStack {
            Text("Name: " + folder.name)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("League: " + folder.league.title)
                .font(.title)
                .foregroundColor(.white)
            Text("# of Cards: " + String(folder.cards.count))
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
