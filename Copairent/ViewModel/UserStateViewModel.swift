//
//  UserStateViewModel.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/3/24.
//

import Foundation
import SwiftUI

enum UserStateError: Error{
    case signInError, signOutError
}

@MainActor
class UserStateViewModel: ObservableObject{
    @Published var networkClient: MockHTTPClient
    @Published var isLoggedIn = false
    @Published var isBusy = false

    init(networkClient: MockHTTPClient){
        self.networkClient = networkClient
    }

    func signIn(email: String, password: String) async -> Result<Bool, UserStateError>  {
        isBusy = true
        do{
            let _ = try await networkClient.signIn(email: email, password: password)
//            try await Task.sleep(nanoseconds:  1_000_000_000)
            print("Signing in")
            isLoggedIn = true
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.signInError)
        }
    }

    func signOut() async -> Result<Bool, UserStateError>  {
        isBusy = true
        do{
            try await Task.sleep(nanoseconds: 1_000_000_000)
            isLoggedIn = false
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.signOutError)
        }
    }
}
