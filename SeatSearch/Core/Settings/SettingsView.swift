//
//  SettingsView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/24/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @Binding var showSignInView: Bool
    
    @State var isShowingResetAlert: Bool = false
    @State var isShowingDeleteAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.blue)
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Text(viewModel.userEmail != nil ? viewModel.userEmail! : "-------")
                            .bold()
                    }
                    
                    if viewModel.authProviders.contains(.email) {
                        Button(role: .destructive) {
                            isShowingResetAlert = true
                        } label: {
                            Text("Reset password")
                        }
                        .alert("Reset Password?", isPresented: $isShowingResetAlert) {
                            Button("Reset", role: .destructive) {
                                isShowingResetAlert = false
                                
                                Task {
                                    do {
                                        try await viewModel.resetPassword()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(role: .destructive) {
                        isShowingDeleteAlert = true
                    } label: {
                        Text("Delete account")
                    }
                    .alert("Delete Account?", isPresented: $isShowingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            isShowingDeleteAlert = false
                            
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                    showSignInView = true
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
                
                Section() {
                    Button("Log out") {
                        Task {
                            do {
                                try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadAuthProviders()
            }
            .navigationTitle("Settings")
        }
        .onChange(of: showSignInView) { newValue in
            if showSignInView == false {
                viewModel.setEmail()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
