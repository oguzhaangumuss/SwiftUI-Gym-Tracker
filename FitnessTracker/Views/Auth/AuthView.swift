import SwiftUI

struct AuthView: View {
    @State private var isShowingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                SignInView()
                
                Button("Hesap Oluştur") {
                    isShowingSignUp = true
                }
                .sheet(isPresented: $isShowingSignUp) {
                    SignUpView()
                }
            }
            .padding()
            .navigationTitle("Fitness Tracker")
        }
    }
}

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Giriş Yap") {
                signIn()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func signIn() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
} 