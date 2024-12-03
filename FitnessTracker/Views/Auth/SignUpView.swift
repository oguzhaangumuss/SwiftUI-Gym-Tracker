import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("Ad", text: $firstName)
                    TextField("Soyad", text: $lastName)
                    TextField("E-posta", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Şifre", text: $password)
                    SecureField("Şifre Tekrar", text: $confirmPassword)
                }
                
                Section(header: Text("Fiziksel Bilgiler")) {
                    TextField("Yaş", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Boy (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    TextField("Kilo (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }
                
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Button("Kayıt Ol") {
                    signUp()
                }
            }
            .navigationTitle("Yeni Hesap")
            .navigationBarItems(trailing: Button("İptal") {
                dismiss()
            })
        }
    }
    
    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Şifreler eşleşmiyor"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            if let userId = result?.user.uid {
                let userData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "age": Int(age) ?? 0,
                    "height": Double(height) ?? 0.0,
                    "weight": Double(weight) ?? 0.0,
                    "isAdmin": false,
                    "createdAt": Timestamp(),
                    "updatedAt": Timestamp()
                ]
                
                FirebaseManager.shared.firestore.collection("users").document(userId).setData(userData) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        dismiss()
                    }
                }
            }
        }
    }
} 