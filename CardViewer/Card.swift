//
//  Card.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import Foundation

struct Card: Identifiable, Codable, Hashable {
    let id: UUID
    var playerName: String
    var team: String
    var frontImageName: Data?
    var backImageName: Data?
    var position: String
    var grade: Int
    
    init(id: UUID = UUID(), playerName: String, team: String, frontImageName: Data?, backImageName: Data?, position: String, grade: Int) {
        self.id = id
        self.playerName = playerName
        self.team = team
        self.frontImageName = frontImageName
        self.backImageName = backImageName
        self.position = position
        self.grade = grade
    }

}
