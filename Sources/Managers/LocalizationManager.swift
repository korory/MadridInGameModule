//
//  LocalizationManager.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    private var strings: [String: String] = [:]

    private init() {}

    func load(items: [TextContentItem]) {
        let langCode = Locale.current.language.languageCode?.identifier ?? "en"
        for item in items {
            guard let key = item.key else { continue }
            let value = langCode == "es" ? item.es : item.en
            if let value {
                strings[key] = value
            }
        }
    }

    func string(for key: String) -> String? {
        return strings[key]
    }
}
