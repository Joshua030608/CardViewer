//
//  NamesCache.swift
//  CardViewer
//
//  Created by Joshua Ford on 10/8/23.
//

import Foundation

actor NamesCache {
    let source: PlayerNameSource
    
    init(source: PlayerNameSource) {
        self.source = source
    }
    
    var names: [String] {
        if let names1 = cachedNames {
            return names1
        }
        
        let namesFromSource = source.loadPlayerNames()
        cachedNames = namesFromSource
        return namesFromSource
    }
    
    private var cachedNames: [String]?
}

extension NamesCache {
    func lookup(prefix: String) -> [String] {
        let filterdNames = names.filter { $0.lowercased().hasPrefix(prefix.lowercased()) }
        return filterdNames
    }
}
