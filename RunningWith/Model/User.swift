

import Foundation
import Firebase

struct User {
    
    let ref: DatabaseReference?
    let id: String
    let email: String
    let username: String
    let nom: String
    let prenom: String
    let imageUrl: String
    
    //    init(authData: Firebase.User) {
    //        self.id = authData.uid
    //        self.email = authData.email!
    //    }
    //
    
    init(email: String, username: String, nom: String, prenom: String, imageUrl: String, id: String = "") {
        self.ref = nil
        self.id = id
        self.email = email
        self.username = username
        self.nom = nom
        self.prenom = prenom
        self.imageUrl = imageUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let username = value["username"] as? String,
            let prenom = value["prenom"] as? String,
            let nom = value["nom"] as? String,
            let imageUrl = value["imageUrl"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.id = snapshot.key
        self.email = email
        self.username = username
        self.prenom = prenom
        self.nom = nom
        self.imageUrl = imageUrl
    }
    
    func toAnyObject() -> [String: AnyObject] {
      return [
        "email": self.email as AnyObject,
        "username": self.username as AnyObject,
        "nom": self.nom as AnyObject,
        "prenom": self.prenom as AnyObject,
        "imageUrl": self.imageUrl as AnyObject
      ]
    }
}
