//
//  TextContentService.swift
//  MadridInGameiOSModule
//

class TextContentService {

    func fetchTextContent() {
        let parameters: [String: String] = [
            "fields": "key,en,es",
            "limit": "-1"
        ]

        Task {
            do {
                let response: TextContentResponse = try await DirectusService.shared.request(
                    endpoint: "text_content_mig",
                    method: .GET,
                    parameters: parameters
                )
                LocalizationManager.shared.load(items: response.data)
            } catch {
                Logger.shared.log("TextContentService error: \(error)")
            }
        }
    }
}
