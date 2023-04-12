//
//  Folder.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import Foundation

enum League: String {
    case NFL = "NFL"
    case NBA = "NBA"
    case MLB = "MLB"
    case NHL = "NHL"
}

struct Folder: Identifiable {
    let id: UUID = UUID()
    var name: String
    var cards: [Card]
    var league: League
}

