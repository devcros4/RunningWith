import UIKit
import AVFoundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthenticationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signInWithAppleBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                BDD().getUser(id: user!.uid) { (user) -> Void in
                    if user != nil {
                        currentUser = user
                        self.performSegue(withIdentifier: "Authentification", sender: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sign in with apple button
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 382, height: 56)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        stackView.insertArrangedSubview(button, at: 1)
    }
    

    // MARK: - SignInWithApple
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    /// encode string in sha256 type
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length
      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }
        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }
          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      return result
    }

}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                var notExiste = false
                var i = 1
                repeat {
                    var username: String {
                        return "\(user.displayName ?? "Runner")\(i)"
                    }
                    BDD().usernameAlreadyExiste(username: username) { (existe, errorMessage) -> Void in
                        if let existe =  existe, existe {
                            notExiste = existe
                        } else {
                            let newUser = User(email: user.email ?? "", username: username, nom: user.displayName ?? "", prenom: "", imageUrl: "")
                            BDD().createOrUpdateUser(user: newUser) { (myUser) -> Void in
                                if let userr = myUser {
                                    currentUser = userr
                                    notExiste = false
                                }
                            }
                        }
                    }
                        i += 1
                    }  while notExiste
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }

}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthenticationViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}
