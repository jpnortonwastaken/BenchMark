//
//  AuthenticationView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/24/23.
//

import SwiftUI
import FirebaseAuth

@MainActor
struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                let img = UIImage(named: "AppIcon")
                if(img != nil) {
                    Image(uiImage: img!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .scaledToFill()
                        .clipped()
                        .shadow(color: Color.black.opacity(0.1), radius: 25, x: 0, y: 5)
                }
                
                Text("BenchMark")
                    .font(.title)
                    .bold()
            }
            
            Spacer()
            
            NavigationLink(destination: {
                SignInEmailView(showSignInView: $showSignInView)
            }, label:  {
                Text("Sign in / Sign up with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            ZStack {
                Divider()
                    .background(Color(UIColor.tertiaryLabel))
                    .frame(height: 80)
                    .padding(.horizontal)
                
                Text("Or continue with")
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .padding(.horizontal, 10)
                    .background(Color(UIColor.systemBackground))
                    .bold()
            }
            
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("Sign in with Google")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(alignment: .leading) {
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding(.leading)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.tertiaryLabel), lineWidth: 3)
                    )
                    .cornerRadius(10)
            })
            
            Spacer()
            Spacer()
        }
        .padding()
        .navigationTitle("Sign in")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
