//
//  Bdd.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 07/11/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Ref {
    let bdd = Database.database().reference()
    let stockage = Storage.storage().reference()
    
//    let test = Database.
    //Database
    var racineUser: DatabaseReference { return bdd.child("user")}
    var racineRun: DatabaseReference { return bdd.child("run")}
    var myRunBDD: DatabaseReference { return racineRun.child(currentUser.id) }

    func userSpecifique(id: String) -> DatabaseReference {
        return racineUser.child(id)
    }
    
    func runSpecifique(id: String) -> DatabaseReference {
        return racineRun.child(id)
    }
    
//    func runSpecifique(key: String, value: String) -> DatabaseReference {
//        return runUserSpecifique(id: value).child(key)
//    }
    
}
