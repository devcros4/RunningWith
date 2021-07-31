import UIKit
import FirebaseDatabase
/// class of run entity
class Run {
    
    let ref: DatabaseReference?
    let id: String
    var titre: String
    var date: Double
    var address: String
    var speed: Double
    var distance: Double
    var imageUrl: String
    var description: String
    var creator: User
    var runners: [User]
    
    init(titre: String, date: Double, address: String, speed: Double, distance: Double, imageUrl: String, description: String, creator: User, runners: [User], id: String = "") {
        self.ref = nil
        self.id = id
        self.creator = creator
        self.runners = runners
        self.titre = titre
        self.date = date
        self.address = address
        self.speed = speed
        self.distance = distance
        self.imageUrl = imageUrl
        self.description = description
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
        self.distance = dict["distance"] as? Double ?? 0
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
    }
    
    init?(snapshot: DataSnapshot, creator: User, runners: [User]) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let titre = value["titre"] as? String,
            let date = value["date"] as? Double,
            let address = value["address"] as? String,
            let speed = value["speed"] as? Double,
            let distance = value["distance"] as? Double,
            let imageUrl = value["imageUrl"] as? String,
            let description = value["description"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.id = snapshot.key
        self.titre = titre
        self.date = date
        self.address = address
        self.speed = speed
        self.distance = distance
        self.runners = runners
        self.imageUrl = imageUrl
        self.description = description
        self.creator = creator
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "titre": self.titre as AnyObject,
            "date": self.date as AnyObject,
            "address": self.address as AnyObject,
            "speed": self.speed as AnyObject,
            "distance": self.distance as AnyObject,
            "creator": self.creator.id as AnyObject,
            "runners": self.todic() as AnyObject,
            "imageUrl": self.imageUrl as AnyObject,
            "description": self.description as AnyObject
        ]
    }
    func todic() -> [String: Bool] {
        var dicRunners = [String: Bool]()
        self.runners.forEach { (user) in
            dicRunners[user.id] = true
        }
        return dicRunners
    }
    
    func getUsers(usersID: [String],  completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        let group = DispatchGroup()
            usersID.forEach { (userID) in
                group.enter()
                BDD().getUser(id: userID, completion: { (user) -> Void in
                    if let user = user {
                        users.append(user)
                        group.leave()
                    }
                })
            }
        group.notify(queue: .main) {
            completion(users)
        }
        completion(users)
    }
}
