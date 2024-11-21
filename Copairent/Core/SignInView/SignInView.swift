//
//  SignInView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/3/24.
//

import SwiftUI

// https://paulallies.medium.com/login-logout-flow-swiftui-and-environmentobject-48ea084c5b6e
struct SignInView: View {

    @EnvironmentObject var vm: UserStateViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignInButtonDisabled = true

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)

                Text("Sign in to your account")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)

                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.top, 30)

                Button(action: {
                    // Perform sign in action
                    Task {
                        await vm.signIn(email: email, password: password)
                    }
                }) {
                    Text("Sign In")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Primary"))
                        .cornerRadius(8)
                }
                .disabled(isSignInButtonDisabled)
                .opacity(isSignInButtonDisabled ? 0.6 : 1)
                .padding(.top, 20)

                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: CreateAccountView(), label: {
                        Text("Create Account")
                    })
                    .navigationBarBackButtonHidden(true)
                    .foregroundColor(Color("Primary"))
                }
                .padding(.top, 15)
            }
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden(true)
        .background(.blue)
        .onChange(of: email) { _ in updateSignInButtonState() }
        .onChange(of: password) { _ in updateSignInButtonState() }
    }

    private func updateSignInButtonState() {
        isSignInButtonDisabled = email.isEmpty || password.isEmpty
    }
}

#Preview {
    PreviewContainerView {
        SignInView()
    }
}
