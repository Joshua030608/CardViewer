//
//  FolderInfoView.swift
//  CardViewer
//
//  Created by Joshua Ford on 7/25/23.
//

import SwiftUI

struct FolderInfoView: View {
    let folder: Folder
    
    var body: some View {
        HStack {
            Text("Name: " + folder.name)
                .font(.largeTitle)
            Text("League: " + folder.league.rawValue)
                .font(.title)
            Text("# of Cards: " + String(folder.cards.count))
                .font(.title)
        }
    }
}
