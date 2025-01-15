//
//  UserDefaultsExtension.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let favoritePairs = "favoritePairs"
    }
    
    var favoritePairs: [FavoritePair] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.favoritePairs) else { return [] }
            return (try? JSONDecoder().decode([FavoritePair].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.favoritePairs)
        }
    }
}
