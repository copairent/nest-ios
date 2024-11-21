//
//  ContentView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @EnvironmentObject var vm: UserStateViewModel

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else if !vm.isLoggedIn {
            SignInView()
        }else {
            AppTabView()
        }
    }
}

#Preview {
    PreviewContainerView {
        ContentView()
    }
}
