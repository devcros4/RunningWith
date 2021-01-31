
import UIKit
import FirebaseDatabase

class Run {
    
    let ref: DatabaseReference?
    let id: String
    var titre: String
    var date: Double
    var address: String
    var speed: Double
    var duration: Double
    var distance: Double
    var level: String
    var creator: User
    var runners: [User]
    
    init(titre: String, date: Double, address: String, speed: Double, duration: Double, distance: Double, level: String, creator: User, runners: [User], id: String = "") {
        self.ref = nil
        self.id = id
        self.creator = creator
        self.runners = runners
        self.titre = titre
        self.date = date
        self.address = address
        self.speed = speed
        self.duration = duration
        self.distance = distance
        self.level = level
    }
    
    init(ref: DatabaseReference, id: String, creator: User, runners: [User], dict: [String: AnyObject]) {
        self.ref = ref
        self.id = id
        self.creator = creator
        self.runners = runners
        self.titre = dict["titre"] as? String ?? ""
        self.date = dict["date"] as? Double ?? 0
        self.address = dict["address"] as? String ?? ""
        self.speed = dict["speed"] as? Double ?? 0
        self.duration = dict["duration"] as? Double ?? 0
        self.distance = dict["distance"] as? Double ?? 0
        self.level = dict["level"] as? String ?? ""
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let creator = value["creator"] as? String,
            let titre = value["titre"] as? String,
            let date = value["date"] as? Double,
            let address = value["address"] as? String,
            let speed = value["speed"] as? Double,
            let duration = value["duration"] as? Double,
            let distance = value["distance"] as? Double,
            let level = value["level"] as? String,
            let runners = value["runners"] as? [String]
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.id = snapshot.key
        self.titre = titre
        self.date = date
        self.address = address
        self.speed = speed
        self.duration = duration
        self.distance = distance
        self.level = level
        self.runners = []
        self.creator = User(email: "", username: "", nom: "", prenom: "", imageUrl: "")
//        if let user = self.getUsers(usersID: [creator]).first {
//            self.creator = user
//        }
//        self.runners = getUsers(usersID: runners)
        
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "titre": self.titre as AnyObject,
            "date": self.date as AnyObject,
            "address": self.address as AnyObject,
            "speed": self.speed as AnyObject,
            "duration": self.duration as AnyObject,
            "distance": self.distance as AnyObject,
            "level": self.level as AnyObject,
            "creator": self.creator.id as AnyObject,
            "runners": self.todic() as AnyObject
        ]
    }
    func todic() -> [String: Bool] {
        var dicRunners = [String: Bool]()
        self.runners.forEach { (user) in
            dicRunners[user.id] = true
        }
        return dicRunners
    }
    
    func getUsers(usersID: [String]) -> [User] {
        var users: [User] = []
        usersID.forEach { (userID) in
            BDD().getUser(id: userID, completion: { (user) -> (Void) in
                if let user = user {
                    users.append(user)
                }
            })
        }
        return users
    }
}
