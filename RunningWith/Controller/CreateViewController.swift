import UIKit
import CoreLocation

class CreateViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var ivImageRun: UIImageView!
    @IBOutlet weak var btDone: UIButton!
    
    // MARK: - Outlets
    var run: Run?
    var imagePicker: ImagePicker!
    var newImage = false
    var informationsTableViewController: InformationsRunTableViewController?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        if let theRun = run {
            self.title = "Update Run"
            if !theRun.imageUrl.isEmpty {
                self.ivImageRun.download(imageUrl: theRun.imageUrl)
                self.ivImageRun.contentMode = .scaleAspectFill
            }
            self.informationsTableViewController?.address = theRun.address
            self.informationsTableViewController?.btLocationRun.setTitle(theRun.address, for: .normal)
            self.informationsTableViewController?.tfTitreRun.text = theRun.titre
            self.informationsTableViewController?.tfSpeedRun.text = "\(theRun.speed)"
            self.informationsTableViewController?.tfDistanceRun.text = "\(theRun.distance)"
            self.informationsTableViewController?.tvDescriptionRun.text = theRun.description
            self.informationsTableViewController?.dpDateRun.date = Date(timeIntervalSinceReferenceDate: theRun.date)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "informations", let destination = segue.destination as? InformationsRunTableViewController {
            informationsTableViewController = destination
        }
    }
    
    // MARK: - Actions
    @IBAction func saveDidTouch(_ sender: UIButton) {
        sender.preventRepeatedPresses(inNext: 3)
        guard let titre = informationsTableViewController?.tfTitreRun.text, !titre.isEmpty else {
            Alerte().messageSimple(controller: self, titre: "Error", message: "Please enter a title")
            return
        }
        guard let date = informationsTableViewController?.dpDateRun.date  else {
            Alerte().messageSimple(controller: self, titre: "Error", message: "Please enter a Date")
            return
        }
        guard let address = informationsTableViewController?.btLocationRun.titleLabel?.text, !address.isEmpty else {
            Alerte().messageSimple(controller: self, titre: "Error", message: "Please enter an address")
            return
        }
        guard let speedString = informationsTableViewController?.tfSpeedRun.text, let speed = Double(speedString) else {
            Alerte().messageSimple(controller: self, titre: "Error", message: "Please enter a speed")
            return
        }
        guard let distanceString = informationsTableViewController?.tfDistanceRun.text, let distance = Double(distanceString) else {
            Alerte().messageSimple(controller: self, titre: "Error", message: "Please enter a distance")
            return
        }
        let description = informationsTableViewController?.tvDescriptionRun.text ?? ""
        sender.isUserInteractionEnabled = false
        if newImage {
            if let image = ivImageRun.image, let data = image.jpegData(compressionQuality: 0.2) {
                let id = UUID().uuidString
                let group = DispatchGroup()
                group.enter()
                    Stockage().addImage(reference: Ref().myRunsImage.child(id), data: data) { (success, urlString) in
                        guard let result = success, result == true, let urlImage = urlString  else {
                            return }
                        self.createOrUpdateRun(titre: titre, date: date.timeIntervalSinceReferenceDate, address: address, speed: speed, distance: distance, urlImage: urlImage, description: description)
                    }
            }
        } else {
            self.createOrUpdateRun(titre: titre, date: date.timeIntervalSinceReferenceDate, address: address, speed: speed, distance: distance, urlImage: "", description: description)
        }
    }
    
    @IBAction func changeImageDidTouch(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    // MARK: - Private methode
    private func createOrUpdateRun(titre: String, date: Double, address: String, speed: Double, distance: Double, urlImage: String, description: String) {
        // run already exist just udapte run
        if let theRun = self.run {
            theRun.titre = titre
            theRun.date = date
            theRun.address = address
            theRun.speed = speed
            theRun.distance = distance
            if self.newImage {
                theRun.imageUrl  = urlImage
            }
            theRun.description = description
            BDD().updateRun(run: theRun) { (success, message) in
                Alerte().messageSimple(controller: self, titre: "Update Run", message: message ?? "") { (action) in
                    if success ?? false {
                        self.getLocation(address: theRun.address) { (location) in
                            BDD().createOrUpdateLocation(location: location ?? CLLocation(latitude: 37.7853889, longitude: -122.4056973), runId: theRun.id)
                        }
                        let notif = Notif(run: theRun, date: Date().timeIntervalSinceReferenceDate, titre: "Update", texte: "The run \(theRun.titre) in which you participate has been modified.")
                        theRun.runners.forEach { (user) in
                            BDD().sendNotification(id: user.id, notif: notif)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            // create a new run
            let newRun = Run(titre: titre, date: date, address: address, speed: speed, distance: distance, imageUrl: urlImage, description: description, creator: currentUser, runners: [currentUser])
            self.getLocation(address: newRun.address) { (location) in
                BDD().createRun(run: newRun, location: location ?? CLLocation(latitude: 37.7853889, longitude: -122.4056973)) { (success, message) in
                    Alerte().messageSimple(controller: self, titre: "New run", message: message ?? "")
                    if success ?? false {
                        self.resetPage()
                    }
                }

            }
        }
    }
    
    /// reset all component of the page
    private func resetPage() {
        self.ivImageRun.image = UIImage(named: "addPicture")
        self.ivImageRun.contentMode = .center
        self.informationsTableViewController?.address = ""
        self.informationsTableViewController?.btLocationRun.setTitle("Add Address", for: .normal)
        self.informationsTableViewController?.tfTitreRun.text = ""
        self.informationsTableViewController?.tfSpeedRun.text = ""
        self.informationsTableViewController?.tfDistanceRun.text = ""
        self.informationsTableViewController?.tvDescriptionRun.text = ""
        self.informationsTableViewController?.dpDateRun.date = Date()
        self.btDone.isUserInteractionEnabled = true
    }
    
    
    /// get location from addresse
    /// - Parameters:
    ///   - address: adresse from
    ///   - completion: location return
    private func getLocation(address: String, completion: @escaping (_ location: CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                completion(placemarks?.first?.location)
            } else {
                completion(nil)
            }
        }
    }
    
    
}
// MARK: - ImagePickerDelegate
extension CreateViewController: ImagePickerDelegate {
    
    /// func call after selection of image
    /// - Parameter image: image in return
    func didSelect(image: UIImage?) {
        if let newImg = image {
            self.ivImageRun.image = newImg
            self.ivImageRun.contentMode = .scaleAspectFill
            self.newImage = true
        }
    }
}
