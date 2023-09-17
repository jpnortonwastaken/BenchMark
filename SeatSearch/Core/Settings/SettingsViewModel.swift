//
//  SettingsViewModel.swift
//  SeatSearch
//
//  Created by JP Norton on 9/7/23.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    @Published var userEmail: String? = nil
    
    init() {
        do {
            self.userEmail = try getUserEmail()
        } catch {
            print(error)
        }
    }
    
    func setEmail() {
        do {
            self.userEmail = try getUserEmail()
        } catch {
            print(error)
        }
    }
    
    func getUserEmail() throws -> String {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            print("Function Error")
            throw URLError(.fileDoesNotExist)
        }
        
        return email
    }
    
    func loadAuthProviders() {
        if let providers =  try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword(password: String) async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateEmail(email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
}
