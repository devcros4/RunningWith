//
//  Alerte.swift
//  CodaGram
//
//  Created by Matthieu PASSEREL on 13/01/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit
import FirebaseAuth

class Alerte {
    
    func erreurSimple(controller: UIViewController, message: String) {
        let alerte = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    
    func camera(controller: UIViewController, picker: UIImagePickerController) {
        let alerte = UIAlertController(title: "Choisir une photo", message: nil, preferredStyle: .alert)
        let appareil = UIAlertAction(title: "Appareil photo", style: .default) { (action) in
            picker.sourceType = .camera
            controller.present(picker, animated: true, completion: nil)
        }
        let librairie = UIAlertAction(title: "Librairie de photos", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            controller.present(picker, animated: true, completion: nil)
        }
        let annuler = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alerte.addAction(appareil)
        alerte.addAction(librairie)
        alerte.addAction(annuler)
        controller.present(alerte, animated: true, completion: nil)
    }
    
    func deconnection(controller: UIViewController) {
        let alerte = UIAlertController(title: "Etes-vous sûr de vouloir vous déconnecter?", message: nil, preferredStyle: .alert)
        let oui = UIAlertAction(title: "OUI", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
            controller.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        let non = UIAlertAction(title: "NON", style: .cancel, handler: nil)
        alerte.addAction(oui)
        alerte.addAction(non)
        controller.present(alerte, animated: true, completion: nil)
    }
    
}












