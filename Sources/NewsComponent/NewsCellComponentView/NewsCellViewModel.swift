//
//  NewsViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//


import Foundation

class NewsCellViewModel: ObservableObject {
    @Published var news: NewsModel
    
    init(news: NewsModel) {
        self.news = news
    }
}

//
//    let news: NewsModel
//    let editNews:(NewsModel) -> Void
//    let deleteNew:(NewsModel) -> Void
    
//    func fetchNews() {
//        // Implementar la lógica de obtención de noticias
//    }
//    
//    func editNews(_ news: NewsModel) {
//        // Implementar la lógica para editar la noticia
//    }
//    
//    func deleteNews(_ news: NewsModel) {
//        // Implementar la lógica para eliminar la noticia
//    }
//}
