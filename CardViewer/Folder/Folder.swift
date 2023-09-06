//
//  Folder.swift
//  CardViewer
//
//  Created by Joshua Ford on 4/11/23.
//

import Foundation

enum League: Int, Codable, CaseIterable, Identifiable {
    var id: League { self }
    
    case NFL, NBA, MLB, NHL
    
    var title: String {
        switch self {
            case .NFL: return "NFL"
            case .NBA: return "NBA"
            case .MLB: return "MLB"
            case .NHL: return "NHL"
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .NFL:
            return "football.fill"
        case .NBA:
            return "basketball.fill"
        case .MLB:
            return "baseball.fill"
        case .NHL:
            return "hockey.puck.fill"
        }
    }
}

class Folder: Identifiable, Codable, ObservableObject, Hashable {
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.cards == rhs.cards && lhs.league == rhs.league
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(cards)
        hasher.combine(league)
    }
    
    private enum CodingKeys: CodingKey {
        case id
        case name
        case cards
        case league
    }
    
    let id: UUID
    @Published var name: String
    @Published var cards: [Card]
    let league: League
    
    init(id: UUID = UUID(), name: String, cards: [Card], league: League) {
        self.id = id
        self.name = name
        self.cards = cards
        self.league = league
    }
    //This init is used in FolderStore load folders func, probably not needed in future
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cards = try container.decode([Card].self, forKey: .cards)
        league = try container.decode(League.self, forKey: .league)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cards, forKey: .cards)
        try container.encode(league, forKey: .league)
    }
    //Not sure if these are neccessary here. I think these should be in folderStore but idk
    
    func deleteCard(indices: IndexSet, folderStore: FolderStore) {
        Array<Int>(indices).reversed().forEach { cards.remove(at: $0) }
        folderStore.save(folder: self)
    }
}

extension Array: Identifiable where Element: Hashable {
    public var id: UUID { UUID() }
 }

