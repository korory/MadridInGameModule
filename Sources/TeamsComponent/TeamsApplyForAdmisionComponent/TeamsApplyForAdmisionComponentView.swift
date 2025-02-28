//
//  TeamsApplyForAdmisionComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct TeamsApplyForAdmisionComponentView: View {
    var body: some View {
        VStack {
            titleComponent
            searchBarComponent
        }
    }
}

extension TeamsApplyForAdmisionComponentView {
    private var titleComponent: some View {
        Text("BUSCA EQUIPOS")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Color.white)
    }
    
    private var searchBarComponent: some View {
        VStack {
            //TODO: Add SearchBar with back connection
        }
    }
}

