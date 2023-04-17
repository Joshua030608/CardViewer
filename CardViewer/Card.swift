//
//  Card.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import Foundation

struct Card: Identifiable, Codable {
    let id: UUID
    var playerName: String
    var team: String
    var imageName: String
    var position: String
    
    init(id: UUID = UUID(), playerName: String, team: String, imageName: String, position: String) {
        self.id = id
        self.playerName = playerName
        self.team = team
        self.imageName = imageName
        self.position = position
    }

}
