import Foundation
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import GeoFire

/// class of action on the BDD firebase
class BDD {
    
    /// token authentification
    var auth: Auth = Auth.auth()
    
    
    /// create the new user in authentification service firebase
    /// - Parameters:
    ///   - email: user email address
    ///   - password: user password
    ///   - completion: a block which is invoked when the sign up flow finishes, or is canceled. Invoked asynchronously on the main thread in the future.
    func createUserForAuthentification(email: String, password: String, completion: AuthDataResultCallback?) {
        auth.createUser(withEmail: email, password: password, completion: completion)
    }
    
    /// Signs in using an email address and password in authentification service firebase
    /// - Parameters:
    ///   - email: user email address
    ///   - password: user password
    ///   - completion: a block which is invoked when the sign in flow finishes, or is canceled. Invoked asynchronously on the main thread in the future.
    func signIn(email:String, password: String, completion: AuthDataResultCallback?) {
        auth.signIn(withEmail: email, password: password, completion: completion)
    }
    
    /// Signs out the current user in authentification service firebase
    /// - Parameter completion: status of response and if an error occurs, upon return contains an NSError object that describes the problem; is nil otherwise.
    func signOut(completion: SuccessCompletion) {
        do {
            try auth.signOut()
            completion(true, "")
        } catch (let error) {
            completion(false, "Auth sign out failed: \(error)")
        }
    }
    
    /// nitiates a password reset for the given email address.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - completion: a block which is invoked when the request finishes. Invoked asynchronously on the main thread in the future.
    func resetPassword(email: String, completion: @escaping SuccessCompletion) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let mistake = error {
                completion(false, mistake.localizedDescription)
            } else {
                completion(true, "an email has been sent to your address. Follow the instructions provided to reset your password.")
            }
        }
    }
    
    
    /// get user with id
    /// - Parameters:
    ///   - id: id of the user
    ///   - completion: completion user if exist
    func getUser(id: String, completion: UserCompletion?) {
        Ref().userSpecifique(id: id).observe(.value) { (snapshot) in
            if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                completion?(User(snapshot: snapshot))
            } else {
                completion?(nil)
            }
        }
    }
    
    
    /// create a user with id of authentification if exist just update all balue
    /// - Parameters:
    ///   - user: user to create or update
    ///   - completion: completion the user
    func createOrUpdateUser(user: User, completion: UserCompletion?) {
        guard let id = Auth.auth().currentUser?.uid else { completion?(nil); return }
        Ref().userSpecifique(id: id).updateChildValues(user.toAnyObject()) { (error, _) in
            if error == nil {
                self.getUser(id: id, completion: { (user) -> Void in
                    completion?(user)
                })
            } else {
                completion?(nil)
            }
        }
    }
    
    
    /// check if username is already use by an other user
    /// - Parameters:
    ///   - username: username to check
    ///   - completion: completion true or false
    func usernameAlreadyExiste(username: String, completion: SuccessCompletion?) {
        Ref().racineUser.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion?(true, "username already existe")
            } else {
                completion?(false, nil)
            }
        }
    }
    
    /// check if email is already use by an other user
    /// - Parameters:
    ///   - email: username to check
    ///   - completion: completion true or false
    func emailAdrresseAlreadyUse(email: String, completion: SuccessCompletion?) {
        Ref().racineUser.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion?(true, "email already use")
            } else {
                completion?(false, nil)
            }
        }
    }
    
    
    /// create or update location for key
    /// - Parameters:
    ///   - location: location
    ///   - runId: key
    func createOrUpdateLocation(location: CLLocation, runId: String) {
        Ref().geoFire.setLocation(location, forKey: runId)
    }
    
    
    /// remove location for key
    /// - Parameter runId: key
    func removeLocation(runId: String) {
        Ref().geoFire.removeKey(runId)
    }
    
    
    /// create a run in bdd
    /// - Parameters:
    ///   - run: run to create
    ///   - location: location of run
    ///   - completion: completion response of request
    func createRun(run: Run, location: CLLocation, completion: SuccessCompletion?) {
        Ref().racineRun.childByAutoId().updateChildValues(run.toAnyObject()) { (error, ref) in
            if error == nil {
                self.createOrUpdateLocation(location: location, runId: ref.key ?? "")
                completion?(true, "The run \(run.titre) has been created")
            } else {
                completion?(false, "error when creating the run")
            }
        }
    }
    
    
    /// get run by id
    /// - Parameters:
    ///   - id: id of the run
    ///   - completion: run found or not
    func getRun(id: String, completion: RunCompletion?) {
        Ref().runSpecifique(id: id).observe(.value) { (snapshot) in
            if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                self.convertRun(snapshot: snapshot) { (run) in
                        completion?(run)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    /// get all run of creator equal current user
    /// - Parameter completion: run found
    func getRunsCreateByUser(completion: RunCompletion?) {
        Ref().racineRun.queryOrdered(byChild: "creator").queryEqual(toValue: currentUser.id).observe(.childAdded) { (snapshot) in
                    self.convertRun(snapshot: snapshot) { (run) in
                            completion?(run)
                    }
        }
    }
    
    /// get all run of current user is in runners and not creator
    /// - Parameter completion: run found
    func getRunsJoinByUser(completion: RunCompletion?) {
        Ref().racineRun.queryOrdered(byChild: "runners/\(currentUser.id)").queryEqual(toValue: true).observe(.childAdded) { (snapshot) in
                    self.convertRun(snapshot: snapshot) { (run) in
                        if let theRun = run {
                            if theRun.creator.id != currentUser.id {
                                completion?(theRun)
                            }
                        }
                        completion?(nil)
                    }
        }
    }
    
    /// find a run to join. a run near you and follow the filter
    /// - Parameters:
    ///   - location: location of user
    ///   - startDate: startdate filter
    ///   - endDate: enddate filter
    ///   - distanceMax: distancemax filter
    ///   - completion: completion async run
    func findRuns(location: CLLocation, startDate: Double?, endDate: Double?, distanceMax: Int?, completion: RunCompletion?) {
        var keys: [String] = []
        let query = Ref().geoFire.query(at: location, withRadius: 1000)
        query.observe(.keyEntered, with: { (key: String, location: CLLocation) in
            keys.append(key)
        })
        query.observeReady {
            for key in keys {
                Ref().runSpecifique(id: key).observe(.value) { (snapshot) in
                    if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                        self.convertRun(snapshot: snapshot) { (theRun) in
                            if let run = theRun {
                                if run.creator.id != currentUser.id && !run.runners.contains(where: {$0.id == currentUser.id}) && ((startDate ?? Date().timeIntervalSinceReferenceDate)...(endDate ?? 4027049530)).contains(run.date) {
                                    if let distance = distanceMax {
                                        if Int(run.distance) < distance {
                                            query.removeAllObservers()
                                            completion?(run)
                                        }
                                    } else {
                                        query.removeAllObservers()
                                        completion?(run)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            query.removeAllObservers()
            completion?(nil)
        }
    }
    
    
    /// update run in parameter
    /// - Parameters:
    ///   - run: run edit
    ///   - completion: response request
    func updateRun(run: Run, completion: SuccessCompletion?) {
        Ref().runSpecifique(id: run.id).updateChildValues(run.toAnyObject()) { (error, ref) in
            if error == nil {
                completion?(true, "The run \(run.titre) has been updated")
            } else {
                completion?(false, "error when updating the run")
            }
        }
    }
    
    
    /// remove run in parameter
    /// - Parameters:
    ///   - run: run want remove
    ///   - completion: request response
    func removeRun(run: Run, completion: @escaping SuccessCompletion) {
        if let ref = run.ref {
            ref.removeValue { (error, ref) in
                if let erreur = error {
                    completion(false, erreur.localizedDescription)
                } else {
                    self.removeLocation(runId: run.id)
                    completion(true, "The run \(run.titre) has been deleted")
                }
            }
        } else {
            completion(false, "ref of the run is nil")
        }
    }
    
    
    /// send a notification to a user
    /// - Parameters:
    ///   - id: id of user
    ///   - notif: notification want to send
    func sendNotification(id: String, notif: Notif) {
        Ref().notifUser(id: id).childByAutoId().updateChildValues(notif.toAnyObject())
    }
    
    
    /// get all notification of current user
    /// - Parameter completion: completion notif
    func getAllNotification(completion: @escaping NotifCompletion) {
        Ref().myNotifs.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                if let runId = dict["run"] as? String {
                    self.getRun(id: runId) { (run) in
                        if let no = Notif(snapshot: snapshot, run: run) {
                            completion(no)
                        }
                    }
                } else {
                    if let no = Notif(snapshot: snapshot, run: nil) {
                        completion(no)
                    }
                }
            } 
            completion(nil)
        }
    }
    
    
    /// private func convert a snapshoto to a run
    /// - Parameters:
    ///   - snapshot: snapshot source
    ///   - completion: async completion with run
    private func convertRun(snapshot: DataSnapshot, completion: @escaping (Run?) -> Void) {
        let group = DispatchGroup()
        if let value = snapshot.value as? [String: AnyObject] {
            var runnersFind: [User] = []
            var creator = User(email: "", username: "", nom: "", prenom: "", imageUrl: "")
            if let creatorId = value["creator"] as? String {
                group.enter()
                self.getUser(id: creatorId) { (userCreator) in
                    if let host = userCreator {
                        creator = host
                    }
                    
                    if let runners = value["runners"] as? [String: AnyObject] {
                        group.enter()
                        Array(runners.keys).forEach { (runnerId) in
                            group.enter()
                            self.getUser(id: runnerId) { (user) in
                                if let TheUser = user {
                                    runnersFind.append(TheUser)
                                }
                                group.leave()
                            }
                        }
                        group.leave()
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(Run(snapshot: snapshot, creator: creator, runners: runnersFind))
            }
        } else {
            completion(nil)
        }
    }
}
