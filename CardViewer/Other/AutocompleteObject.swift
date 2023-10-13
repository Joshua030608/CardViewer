//
//  AutocompleteObject.swift
//  CardViewer
//
//  Created by Joshua Ford on 10/8/23.
//

import Foundation

@MainActor
final class AutocompleteObject: ObservableObject {

    @Published var suggestions: [String] = []

    private let namesCache = NamesCache(source: NetworkService.shared)

    private var task: Task<Void, Never>?

    func autocomplete(_ text: String) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(0.3 * 1_000_000_000.0))
            } catch {
                return
            }
            
            
            guard !Task.isCancelled else {
                return
            }

            let newSuggestions = await namesCache.lookup(prefix: text)

            if isSuggestion(in: suggestions, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            } else {
                suggestions = newSuggestions
            }
        }
    }

    private func isSuggestion(in suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first, suggestions.count == 1 else {
            return false
        }

        return suggestion.lowercased() == text.lowercased()
    }
}
