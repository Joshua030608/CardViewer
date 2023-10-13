//
//  NamesCache.swift
//  CardViewer
//
//  Created by Joshua Ford on 10/8/23.
//

import Foundation

@Observable class NamesCache {
    let source: NetworkService
    var names: [String] = []
    
    
    init(source: NetworkService) {
        self.source = source
        source.getPlayerNames { [weak self] names in
            self?.names = names
        }
    }
        
    func lookup(prefix: String) -> [String] {
            let filteredNames = names.filter { $0.lowercased().hasPrefix(prefix.lowercased()) }
            return filteredNames
    }
}
