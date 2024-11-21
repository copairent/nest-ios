//
//  CreateAccountView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/7/24.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isCreateAccountButtonDisabled = true

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("CoPairent")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top, 50)

                Text("Create Your Account")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)

                VStack(spacing: 15) {
                    HStack {
                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        TextField("Last Name", text: $lastName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.top, 20)

                Button(action: {
                    // Perform account creation action
                }) {
                    Text("Create Account")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(isCreateAccountButtonDisabled)
                .opacity(isCreateAccountButtonDisabled ? 0.6 : 1)
                .padding(.top, 20)

                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignInView(), label: {Text("Sign In")})
                    .foregroundColor(.blue)
                }
                .padding(.top, 15)
            }
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: firstName) { _ in updateCreateAccountButtonState() }
        .onChange(of: lastName) { _ in updateCreateAccountButtonState() }
        .onChange(of: email) { _ in updateCreateAccountButtonState() }
        .onChange(of: password) { _ in updateCreateAccountButtonState() }
        .onChange(of: confirmPassword) { _ in updateCreateAccountButtonState() }
    }

    private func updateCreateAccountButtonState() {
        isCreateAccountButtonDisabled = firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
    }
}

#Preview {
    CreateAccountView()
}
