import Foundation
import FirebaseDatabase
import FirebaseStorage
import GeoFire
/// all reference of BDD(data), Stokage(image) and geofire(location)
class Ref {
    
    let bdd = Database.database().reference()
    let stockage = Storage.storage().reference()
    
    //Database ref
    var racineUser: DatabaseReference { return bdd.child("user")}
    var racineRun: DatabaseReference { return bdd.child("run")}
    var racineNotification: DatabaseReference { return bdd.child("notification")}
    var racineUserLocation: DatabaseReference { return bdd.child("run_location")}
    
    var myRunBDD: DatabaseReference { return racineRun.child(currentUser.id)}
    var myNotifs: DatabaseReference { return racineNotification.child(currentUser.id)}
    
    /// get ref of user of the user
    /// - Parameter id: user
    /// - Returns: ref
    func userSpecifique(id: String) -> DatabaseReference {
        return racineUser.child(id)
    }
    
    /// get ref of run of the user
    /// - Parameter id: user
    /// - Returns: ref
    func runSpecifique(id: String) -> DatabaseReference {
        return racineRun.child(id)
    }
    
    /// get ref of notif of the user
    /// - Parameter id: user
    /// - Returns: ref
    func notifUser(id: String) -> DatabaseReference {
        return racineNotification.child(id)
    }

    
    //STOCKAGE
    var racineRunImage: StorageReference { return stockage.child("runs")}
    var myRunsImage: StorageReference { return racineRunImage.child(currentUser.id)}
    var racineProfilImage: StorageReference { return stockage.child("profil")}
    var myProfilImage: StorageReference { return racineProfilImage.child(currentUser.id)}
    
    //GEOFIRE
    var geoFire: GeoFire { return GeoFire(firebaseRef: self.racineUserLocation)}
}
