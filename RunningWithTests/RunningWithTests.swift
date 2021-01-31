//
//  RunningWithTests.swift
//  RunningWithTests
//
//  Created by DELCROS Jean-baptiste on 21/10/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import XCTest
import FirebaseDatabase
@testable import RunningWith

class RunningWithTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitRunWithSanpshot() {
        let snapshot: DataSnapshot = DataSnapshot().
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        BDD().createUserForAuthentification(email: "tet", password: "tt") { (a, b) in
//            print("ok")
//        }
//        BDD().signIn(email: "tet", password: "tt") { (a, b) in
//            print("ok1")
//        }
//        let user = User(email: "rgrtgt", username: "rtgtr", nom: "gthythy", prenom: "hyhy", imageUrl: "ythyhhyt")
//        BDD().createOrUpdateUser(dict: user.toAnyObject()) { (user) -> (Void) in
//            print(user)
//        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
