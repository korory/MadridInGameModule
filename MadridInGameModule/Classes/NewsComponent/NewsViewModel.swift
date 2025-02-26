//
//  NewsViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var allNews: [NewsModel] = []
    @Published var newSelected: Bool = false
    @Published var newsSelected: NewsModel?

//    @Published var createNewNews: Bool = false
//    @Published var selectedNew: NewsModel?
//    @Published var editNew: Bool = false
//    @Published var deleteNews: Bool = false
    @Published var userManager = UserManager.shared
    
    @Published var isLoading = true

    init() {
        self.newsSelected = nil
    }
    
    func getAllNews()  {
        guard let selectedTeam = userManager.getSelectedTeam() else { return }
        
        self.isLoading = true
        
        self.allNews.removeAll()
        TeamNewsService().getTeamNews(teamId: selectedTeam.id) { [weak self] result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    
                    for new in news {
                        self?.allNews.append(new)
                    }
                    self?.isLoading = false

                }
            case .failure(let failure):
                print(failure)
                self?.isLoading = false
            }
        }
    }
    
    func setNewsSelected(_ news: NewsModel) {
        self.newsSelected = news
        self.newSelected = true
    }

    
//    func editNewsToArray(newSelected: NewsModel) {
//        if let index = self.allNews.firstIndex(where: { $0.id == newSelected.id }) {
//            self.allNews[index] = newSelected
//        } else {
//            self.allNews.append(newSelected)
//        }
//    }
//    
//    func deleteNewsToArray() {
//        if let index = self.allNews.firstIndex(where: { $0.id == self.selectedNew?.id ?? UUID() }) {
//            self.allNews.remove(at: index)
//        }
//    }
}
