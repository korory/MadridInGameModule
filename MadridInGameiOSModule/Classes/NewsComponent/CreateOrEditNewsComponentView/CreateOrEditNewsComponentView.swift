////
////  CreateOrEditNewsComponentView.swift
////  CalendarComponent
////
////  Created by Arnau Rivas Rivas on 17/10/24.
////
//
//import SwiftUI
//
//struct CreateOrEditNewsComponentView: View {
//    @State var newsInformation: NewsModel?
//    var createNew: Bool = false
//    //let rejectAction: () -> Void
//    //let publishAction: (NewsModel) -> Void
//    
//    init(createNew: Bool, newsInformation: NewsModel? = mockOneNewEmpty, rejectAction: @escaping () -> Void, publishAction: @escaping (NewsModel) -> Void) {
//        self.createNew = createNew
//        self.newsInformation = newsInformation
//        //self.rejectAction = rejectAction
//        //self.publishAction = publishAction
//    }
//    
//    var body: some View {
//        VStack {
//            titleBanner
//            completeFormComponent
//            selectImageComponent
//            buttonsDiscardSaveComponent
//        }
//    }
//}
//
//extension CreateOrEditNewsComponentView {
//    private var titleBanner: some View {
//        Text(createNew ? "CREAR NOTICIA" : "EDITAR NOTICIA")
//            .font(.largeTitle)
//            .foregroundStyle(Color.white)
//    }
//    
//    private var completeFormComponent: some View {
//        VStack (spacing: 28){
//            FloatingTextField(text: createNew ? "" : (newsInformation?.title ?? ""), placeholderText: "Titulo...")
//                .onTextChange { oldValue, newValue in
//                    self.newsInformation?.title = newValue
//                }
//            
//            FloatingTextField(text: createNew ? "" : (newsInformation?.description ?? ""), placeholderText: "Escribe aquí la noticia...", isDescripcionTextfield: true)
//                .onTextChange { oldValue, newValue in
//                    self.newsInformation?.description = newValue
//                }
//        }
//    }
//    
//    private var selectImageComponent: some View {
//        AvatarComponentView(enablePress: true, imageSelected: { imageSelected in
//            newsInformation?.image = imageSelected
//        })
//    }
//    
//    private var buttonsDiscardSaveComponent: some View {
//        HStack (spacing: 10){
//            CustomButton(text: "Descartar",
//                         needsBackground: false,
//                         backgroundColor: Color.cyan,
//                         pressEnabled: true,
//                         widthButton: 180, heightButton: 50) {
//                //rejectAction()
//
//            }
//                         .padding(.trailing, 10)
//            CustomButton(text: createNew ? "Publicar" : "Guardar",
//                         needsBackground: true,
//                         backgroundColor: Color.cyan,
//                         pressEnabled: true,
//                         widthButton: 180, heightButton: 50) {
//                //publishAction(newsInformation ?? mockOneNewEmpty)
//            }
//        }
//    }
//}
