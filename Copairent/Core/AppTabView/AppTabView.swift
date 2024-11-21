//
//  AppTabView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/11/24.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Calendar", systemImage: "calendar") {
                CalendarView()
            }
            Tab("Family", systemImage: "person") {
                FamilyView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    PreviewContainerView {
        AppTabView()
    }
}
