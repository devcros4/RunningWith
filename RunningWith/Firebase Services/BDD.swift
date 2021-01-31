//
//  Bdd.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 07/11/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class BDD {
    
    func createUserForAuthentification(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func signIn(email:String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut(completion: SuccessCompletion) {
        do {
            try Auth.auth().signOut()
            completion(true, "")
        } catch (let error) {
            completion(false, "Auth sign out failed: \(error)")
        }
    }
    
    
    func getUser(id: String, completion: UserCompletion?) {
        Ref().userSpecifique(id: id).observe(.value) { (snapshot) in
            if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                completion?(User(snapshot: snapshot))
            } else {
                completion?(nil)
            }
        }
    }
    
    func getAllUser(completion: UsersCompletion?) {
        var users: [User] = []
        Ref().racineUser.queryOrdered(byChild: "username").observe(.value) { (snapshot) in
            print(snapshot)
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let user = User(snapshot: snapshot) {
                    users.append(user)
                }
            }
            completion?(users)
        }
    }
    
    func createOrUpdateUser(user: User, completion: UserCompletion?) {
        guard let id = Auth.auth().currentUser?.uid else { completion?(nil); return }
        Ref().userSpecifique(id: id).updateChildValues(user.toAnyObject()) { (error, _) in
            if error == nil {
                self.getUser(id: id, completion: { (user) -> Void in
                    completion?(user)
                })
            }
        }
    }
    
    func usernameAlreadyExiste(username: String, completion: SuccessCompletion?) {
        Ref().racineUser.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                completion?(true, "username already existe")
            } else {
                completion?(false, "")
            }
        }
    }
    
    func emailAdrresseAlreadyUse(email: String, completion: SuccessCompletion?) {
        Ref().racineUser.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion?(true, "")
            } else {
                completion?(false, "email already use")
            }
        }
    }
    
    
    func createRun(run: Run, completion: SuccessCompletion?) {
        Ref().racineRun.childByAutoId().updateChildValues(run.toAnyObject()) { (error, ref) in
            if error == nil {
                completion?(true, "")
            } else {
                completion?(false, "error when creating the run")
            }
        }
    }
    
    
    
    func getRunsCreateByUser(completion: RunsCompletion?) {
        var runs: [Run] = []
        Ref().racineRun.queryOrdered(byChild: "creator").queryEqual(toValue: "CZVVCG50gCdhgsQzhMkhGSKRzXp2").observe(.value) { (snapshot) in
            print(snapshot)
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let run = Run(snapshot: snapshot) {
                    runs.append(run)
                }
            }
            completion?(runs)
        }
    }
    
    
    func getRunsJoinByUser(completion: RunsCompletion?) {
        var runs: [Run] = []
        Ref().racineRun.queryOrdered(byChild: "runners").queryEqual(toValue: 1).observe(.value) { (snapshot) in
            print(snapshot)
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let run = Run(snapshot: snapshot) {
                    runs.append(run)
                }
            }
            completion?(runs)
        }

    }
    
    func getAllRuns(completion: RunsCompletion?) {
        var runs: [Run] = []
        Ref().racineRun.observe(.value) { (snapshot) in
            for child in snapshot.children {
                print(child)
                print(Run(snapshot: (child as? DataSnapshot)!))
                if let snapshot = child as? DataSnapshot, let run = Run(snapshot: snapshot) {
                    runs.append(run)
                }
            }
            completion?(runs)
        }
    }
    
    func updateRun(run: Run, completion: SuccessCompletion?) {
        Ref().runSpecifique(id: run.id).updateChildValues(run.toAnyObject()) { (error, ref) in
            if error == nil {
                completion?(true, "")
            } else {
                completion?(false, "error when updating the run")
            }
        }
    }
    
    func removeRun(run: Run) {
        if run.ref != nil {
            run.ref!.removeValue()
        }
    }
    
}
