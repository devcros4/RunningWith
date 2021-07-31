import UIKit

class ProfilViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var ivAvatar: ImageArrondie!
    @IBOutlet weak var lbFirstLastName: UILabel!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    // MARK: - Properties
    var imagePicker: ImagePicker!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.tfUsername.addBottomBorderWithColor(color: UIColor(named: "separatorColor")!, width: 1)
        self.tfEmail.addBottomBorderWithColor(color: UIColor(named: "separatorColor")!, width: 1)
        self.tfUsername.text = currentUser.username
        self.tfEmail.text = currentUser.email
        self.lbFirstLastName.text = "\(currentUser.prenom) \(currentUser.nom)"
        self.ivAvatar.download(imageUrl: currentUser.imageUrl)
    }
    
    override func viewDidLayoutSubviews() {
        self.ivAvatar.rounded()
    }
    
    // MARK: - Actions
    @IBAction func logOutDidTouch(_ sender: UIBarButtonItem) {
        Alerte().logOut(controller: self)
    }
    
    @IBAction func changeImageDidTouch(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func usernameEditDidEnd(_ sender: UITextField) {
        guard let username = self.tfUsername.text else {
            return
        }
        BDD().usernameAlreadyExiste(username: username) { (existe, errorMessage) in
            if let existe =  existe, existe {
                Alerte().messageSimple(controller: self, titre: "Erreur", message: errorMessage ?? "")
            } else {
                currentUser.username = username
                BDD().createOrUpdateUser(user: currentUser) { (user) in
                    if let returnUser = user {
                        currentUser = returnUser
                    }
                }
            }
        }
        
    }
    
    @IBAction func emailEditDidEnd(_ sender: UITextField) {
        guard let email = self.tfEmail.text else {
            return
        }
        currentUser.email = email
        BDD().createOrUpdateUser(user: currentUser) { (user) in
            if let returnUser = user {
                currentUser = returnUser
            }
        }
    }
}
// MARK: - ImagePickerDelegate
extension ProfilViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let newImage = image, let data = newImage.jpegData(compressionQuality: 0.2) {
            Stockage().addImage(reference: Ref().myProfilImage, data: data) { (success, urlString) in
                guard let result = success, result == true, urlString != nil else { return }
                currentUser.imageUrl = urlString!
                BDD().createOrUpdateUser(user: currentUser) { (user) in
                    if user != nil {
                        currentUser = user
                        self.ivAvatar.download(imageUrl: currentUser.imageUrl)
                    }
                }
            }
        }
    }
}
