//
//  NewsViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//


import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var allNews: [NewsModel]
    @Published var createNewNews: Bool = false
    @Published var selectedNew: NewsModel?
    @Published var editNew: Bool = false
    @Published var deleteNews: Bool = false
    
    init(allNews: [NewsModel]) {
        self.allNews = allNews
    }
    
    func editNewsToArray(newSelected: NewsModel) {
        if let index = self.allNews.firstIndex(where: { $0.id == newSelected.id }) {
            self.allNews[index] = newSelected
        } else {
            self.allNews.append(newSelected)
        }
    }
    
    func deleteNewsToArray() {
        if let index = self.allNews.firstIndex(where: { $0.id == self.selectedNew?.id ?? UUID() }) {
            self.allNews.remove(at: index)
        }
    }
}
