//
//  Card.swift
//  CardViewer
//
//  Created by Joshua Ford on 3/31/23.
//

import Foundation

struct Card: Identifiable, Codable, Hashable {
    let id: UUID
    var playerName: String?
    var team: String?
    var frontImageData: Data?
    var backImageData: Data?
    var position: String?
    var grade: Int?
    
    init(id: UUID = UUID(), playerName: String?, team: String?, frontImageData: Data?, backImageData: Data?, position: String?, grade: Int?) {
        self.id = id
        self.playerName = playerName
        self.team = team
        self.frontImageData = frontImageData
        self.backImageData = backImageData
        self.position = position
        self.grade = grade
    }

}
