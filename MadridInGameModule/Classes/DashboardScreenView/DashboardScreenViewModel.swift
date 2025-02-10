//
//  DashboardScreenViewModel.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 6/11/24.
//

import SwiftUI

enum TabBarDashboardBottom: Hashable {
    case calendar
    case reservation
    case teams
    case aboutus
}

class DashboardScreenViewModel: ObservableObject {
    @Published var selectedTab: TabBarDashboardBottom = .calendar
    @Published var optionTabSelected: TabBarDashboardBottom? = .calendar
    @Published var userManager = UserManager.shared

    init() {
        optionTabSelected = .calendar
    }
}
