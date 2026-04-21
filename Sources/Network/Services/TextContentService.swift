//
//  TextContentService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

class TextContentService {

    func getTextContent(completion: @escaping (Result<[TextContentItem], Error>) -> Void) {
        Task {
            do {
                let response: TextContentResponse = try await DirectusService.shared.request(
                    endpoint: "text_content_mig",
                    method: .GET,
                    parameters: ["fields": "key,en,es"]
                )
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
