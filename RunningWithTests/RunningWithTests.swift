import XCTest
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
@testable import RunningWith

class RunningWithTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - firebase tests authentifaction 
    func test_SignUp_ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().createUserForAuthentification(email: "test14@test.fr", password: "azerty") { (success, error) in
            XCTAssertTrue(success != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 7)
    }
    
    func test_SignUp_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().createUserForAuthentification(email: "test@test.fr", password: "azerty") { (success, error) in
            XCTAssertTrue(success == nil)
            XCTAssertTrue(error != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func test_SignIn_ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().signIn(email: "test@test.fr", password: "azerty") { (success, error) in
            XCTAssertTrue(success != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 15)
    }
    
    func test_SignIn_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().signIn(email: "test@test.fr", password: "azerty123") { (success, error) in
            XCTAssertTrue(success == nil)
            XCTAssertTrue(error != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_SignOut_ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        BDD().signOut { (success, error) in
            XCTAssertTrue(success ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
//    func test_SignOut_NoOk() {
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        BDD().signOut { (success, error) in
//            XCTAssertFalse(success ?? false)
//            XCTAssertTrue(!(error?.isEmpty ?? false))
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5)
//    }
    
    func test_resetPassword_ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        BDD().resetPassword(email: "test@test.fr") { (success, error) in
            XCTAssertTrue(success ?? false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_resetPassword_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().resetPassword(email: "test111@test.fr") { (success, error) in
            XCTAssertFalse(success ?? false)
            XCTAssertTrue(!(error?.isEmpty ?? false))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_getUser_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getUser(id: "X8kcjiXzw1U3pviQuVknO8RkdXW2") { (user) in
            XCTAssertTrue(user != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_getUser_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getUser(id: "null") { (user) in
            XCTAssertTrue(user == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_CreateOrUptadeUser_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        let user = User(email: "test@test.fr", username: "jbdelcros", nom: "del", prenom: "jb", imageUrl: "")
        BDD().createOrUpdateUser(user: user) { (newUser) -> Void in
            XCTAssertTrue(newUser != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_CreateOrUptadeUser_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let user = User(email: "test@test.fr", username: "jbdelcros", nom: "del", prenom: "jb", imageUrl: "")
        BDD().createOrUpdateUser(user: user) { (newUser) -> Void in
            XCTAssertTrue(newUser == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_usernameAlreadyExiste_True() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().usernameAlreadyExiste(username: "jbdelcros") { (success, error) in
            XCTAssertTrue(success == true)
            XCTAssertTrue(error != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_usernameAlreadyExiste_False() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().usernameAlreadyExiste(username: "jbdelcros2") { (success, error) in
            XCTAssertTrue(success == false)
            XCTAssertTrue(error == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_emailAdrresseAlreadyUse_True() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().emailAdrresseAlreadyUse(email: "jbdelcros@hotmail.fr") { (success, error) in
            XCTAssertTrue(success == true)
            XCTAssertTrue(error != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_emailAdrresseAlreadyUse_False() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().emailAdrresseAlreadyUse(email: "new@new.fr") { (success, error) in
            XCTAssertTrue(success == false)
            XCTAssertTrue(error == nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    
    
    func test_createRun_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().createRun(run: Run(titre: "test", date: Double(6970001669.968551), address: "314 avenue du colonel jacques couilleau", speed: 6, distance: 10, imageUrl: "", description: "run", creator: User(email: "test@test.fr", username: "jbdelcros", nom: "del", prenom: "jb", imageUrl: ""), runners: []), location: CLLocation(latitude: 43.8990068, longitude: -0.5007571)) { (success, error) in
            XCTAssertTrue(success == true)
            XCTAssertTrue(error != nil)
        }
        wait(for: [expectation], timeout: 15)
    }
    
    func test_getRun_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getRun(id: "null") { (run) in
            XCTAssertTrue(run == nil)
        }
        wait(for: [expectation], timeout: 15)
    }
    
    func test_getRun_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getRun(id: "-MbgCHBrCgLpuoTa-7Gl") { (run) in
            XCTAssertTrue(run != nil)
        }
        wait(for: [expectation], timeout: 15)
    }
    
    func test_getRunsCreateByUser_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        BDD().getRunsCreateByUser { (run) in
            if let theRun = run {
                XCTAssertTrue(theRun.creator.id == currentUser.id)
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_getRunsJoinByUser_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        BDD().getRunsJoinByUser { (run) in
            if let theRun = run {
                XCTAssertTrue(theRun.runners.contains(where: { (user) -> Bool in
                    return user.id == currentUser.id
                }))
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_updateRun_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getRun(id: "-MbgCHBrCgLpuoTa-7Gl") { (run) in
            if let theRun = run {
                theRun.distance = 1
                BDD().updateRun(run: theRun) { (success, error) in
                    XCTAssertTrue(success == true)
                    XCTAssertTrue(error != nil)
                }
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_updateRun_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().updateRun(run:  Run(titre: "test", date: Double(6970001669.968551), address: "314 avenue du colonel jacques couilleau", speed: 6, distance: 10, imageUrl: "", description: "run", creator: User(email: "test@test.fr", username: "jbdelcros", nom: "del", prenom: "jb", imageUrl: ""), runners: [])) { (success, error) in
            XCTAssertTrue(success == false)
            XCTAssertTrue(error != nil)
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_removeRun_Ok() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().getRun(id: "-MbtXgvx2J7ytzpbmRGU") { (run) in
            if let theRun = run {
                BDD().removeRun(run: theRun) { (success, error) in
                    XCTAssertTrue(success == true)
                    XCTAssertTrue(error != nil)
                }
            }
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_removeRun_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        BDD().removeRun(run:  Run(titre: "test", date: Double(6970001669.968551), address: "314 avenue du colonel jacques couilleau", speed: 6, distance: 10, imageUrl: "", description: "run", creator: User(email: "test@test.fr", username: "jbdelcros", nom: "del", prenom: "jb", imageUrl: ""), runners: [])) { (success, error) in
            XCTAssertTrue(success == false)
            XCTAssertTrue(error != nil)
        }
        wait(for: [expectation], timeout: 25)
    }
    
    func test_getAllNotification_NoOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        test_SignIn_ok()
        BDD().getAllNotification { (notif) in
            XCTAssertTrue(notif != nil)
        }
        wait(for: [expectation], timeout: 25)
    }
}
