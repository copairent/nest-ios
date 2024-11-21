//
//  SettingsView.swift
//  Copairent
//
//  Created by Daniel Hunt on 6/11/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: UserStateViewModel
    @State private var toggle: Bool = true

    var body: some View {
        NavigationView {
            Form {
                List {
                    Section(header: Text("General")) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.indigo.opacity(0.3))
                                Image(systemName: "moon.fill")
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.indigo)
                            }

                            Text("Dark Mode")
                            Toggle(isOn: $toggle, label: {
                                Text("")
                            })
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(UIColor.systemGray6))
                    Button(action: {
                        Task {
                            await vm.signOut()
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                            Text("Log Out")
                        }
                    }
                    .tint(.red)                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
        }
    }
}

//#Preview {
//    SettingsView()
//        .previewInWrapper()
//}

#Preview {
    PreviewContainerView {
        SettingsView()
    }
}
