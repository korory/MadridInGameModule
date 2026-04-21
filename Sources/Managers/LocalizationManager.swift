//
//  LocalizationManager.swift
//  MadridInGameiOSModule
//

import Foundation

final class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}

    private var translations: [String: String] = [:]

    func load(items: [TextContentItem]) {
        let primaryLang = Locale.preferredLanguages
            .compactMap { $0.components(separatedBy: "-").first }
            .first ?? "en"
        let useSpanish = primaryLang == "es" || primaryLang == "ca"

        var dict: [String: String] = [:]
        for item in items {
            let value = useSpanish ? item.es : item.en
            if let value, !value.isEmpty {
                dict[item.key] = value
            }
        }
        translations = dict
    }

    func string(for key: String) -> String? {
        return translations[key]
    }
}
