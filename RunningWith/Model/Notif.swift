import Foundation
import FirebaseDatabase
/// class of notif entity
class Notif {
    
    let ref: DatabaseReference?
    let id: String
    var run: Run?
    var date: Double
    var titre: String
    var texte: String
    var view: Bool
    
    init(run: Run?, date: Double, titre: String, texte: String, id: String = "") {
        self.ref = nil
        self.id = id
        self.run = run
        self.date = date
        self.titre = titre
        self.texte = texte
        self.view = false
    }
    
    init?(snapshot: DataSnapshot, run: Run?) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let date = value["date"] as? Double,
            let titre = value["titre"] as? String,
            let texte = value["texte"] as? String,
            let view = value["view"] as? Bool
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.id = snapshot.key
        self.date = date
        self.titre = titre
        self.texte = texte
        self.view = view
        if let theRun = run {
            self.run = theRun
        }
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "titre": self.titre as AnyObject,
            "date": self.date as AnyObject,
            "texte": self.texte as AnyObject,
            "view": self.view as AnyObject,
            "run": self.run?.id as AnyObject
        ]
    }
    
}
