import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let firestore: Firestore
    
    @Published var currentUser: User?
    @Published var isLoading = false
    
    private init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        // Kullanıcı oturum durumunu dinle
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.fetchUserData(userId: user.uid)
            } else {
                self?.currentUser = nil
            }
        }
    }
    
    func fetchUserData(userId: String) {
        isLoading = true
        firestore.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Kullanıcı bilgileri alınamadı: \(error)")
                return
            }
            
            if let data = snapshot?.data() {
                self?.currentUser = User(
                    id: userId,
                    email: data["email"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    age: data["age"] as? Int ?? 0,
                    height: data["height"] as? Double ?? 0.0,
                    weight: data["weight"] as? Double ?? 0.0,
                    isAdmin: data["isAdmin"] as? Bool ?? false
                )
            }
            self?.isLoading = false
        }
    }
} 