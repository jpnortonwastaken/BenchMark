//
//  SignInEmailView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/24/23.
//

import SwiftUI

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .font(.title)
                        .bold()
                    
                    TextField("Email...", text: $viewModel.email)
                        .padding()
                        .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.tertiaryLabel), lineWidth: 3) // Add a red outline
                            )
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .font(.title)
                        .bold()
                    
                    SecureField("Password...", text: $viewModel.password)
                        .padding()
                        .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.tertiaryLabel), lineWidth: 3)
                            )
                        .cornerRadius(10)
                }
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("Sign in / Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            Spacer()
            Spacer()
            Spacer()
        }
        .navigationTitle("Sign in/up with email")
        .padding()
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
