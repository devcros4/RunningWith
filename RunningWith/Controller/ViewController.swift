//
//  ViewController.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 21/10/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var stackViewBtn: UIStackView!
    var user1: User?
    var user3: User?
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("oooo")
        Auth.auth().addStateDidChangeListener() { auth, user in
          if user != nil {
            self.performSegue(withIdentifier: "Authentification", sender: nil)
          }
        }
        self.playVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("okok")
//        BDD().signOut { (success, error) -> (Void) in
//            if success ?? false {
//                print("yes")
//            } else {
//                print(error)
//            }
//        }
        
        
        
//        BDD().createUserForAuthentification(email: "t@hotmail.fr", password: "azerty") { (user, error) in
//            if let erreur = error {
//                Alerte().erreurSimple(controller: self, message: erreur.localizedDescription)
//            }
//            if user != nil {
//                BDD().signIn(email: "t@hotmail.fr", password: "azerty") { (user, error) in
//                    if let realUser = user {
//                        print(user?.user.email)
//                        BDD().getUser(id: realUser.user.uid) { (user) -> (Void) in
//                            if user != nil {
//                                print(user?.id)
//                                currentUser = user
//                            }
//                        }
//                    }
//                }
//            }
//        }
        // MARK: Creation et recuperation d'un user.
//        user1 = User(email: "rgrtgt", username: "rtgtr", nom: "gthythy", prenom: "hyhy", imageUrl: "ythyhhyt")
//        BDD().createOrUpdateUser(dict: user1!.toAnyObject()) { (user) -> (Void) in
//            if let user = user {
//                self.user1 = user
//                currentUser = user
//            }
//        }
//        user3 = User(email: "aaaaa", username: "eeeeee", nom: "rffrfrr", prenom: "aaaaaa", imageUrl: "aaaaa")
//        BDD().createOrUpdateUser(dict: user3!.toAnyObject()) { (user) -> (Void) in
//            if let user = user {
//                self.user3 = user
//            }
//        }
        BDD().getAllUser { (users) -> Void in
            self.user1 = users![1]
            self.user3 = users![2]
            currentUser = users![2]
            print(currentUser)
        }
        
        //        BDD().createOrUpdateUser(dict: ["email": "ok" as AnyObject]) { (user) -> (Void) in
        //            print(user)
        //            print("test")
        //        }
        //        BDD().getUser(id: "CZVVCG50gCdhgsQzhMkhGSKRzXp2") { (user) -> (Void) in
        //            print(user?.ref)
        //            user?.ref?.removeValue()
        //        }
        //        BDD().getUser(id: "ok") { (user) -> (Void) in
        //            print(user?.ref)
        //            user?.ref?.removeValue()
        //        }
        //        BDD().signOut { (success, error) -> (Void) in
        //            print(success)
        //        }
    }
    
//    @IBAction func addrun(_ sender: UIBarButtonItem) {
//        print(currentUser)
//        BDD().createRun(run: Run(titre: "monday", date: Double(12), address: "mdm", speed: Double(14), duration: Double(45), distance: Double(5), level: "good", creator: user1!, runners: [user3!]))
//        BDD().getAllRuns { (runs) -> (Void) in
//            print(runs?.count)
//            runs?.forEach({ (run) in
//                print(run.titre)
//            })
//        }
//        BDD().getRunsJoinByUser { (runs) -> (Void) in
//            print(runs?.count)
//            runs?.forEach({ (run) in
//                print(run)
//            })
//        }
//    }
    override func viewDidDisappear(_ animated: Bool) {
        print("test")
        player?.pause()
    }
    var player: AVPlayer?
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "nike-addiction", ofType: "mp4") else {
            return
        }
        print(path)
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        player!.play()
        self.videoLayer.layer.addSublayer(playerLayer)
        self.videoLayer.bringSubviewToFront(self.icon)
        self.videoLayer.bringSubviewToFront(self.appName)
        self.videoLayer.bringSubviewToFront(self.stackViewBtn)
        self.view.sendSubviewToBack(self.videoLayer)
        self.loopVideo(videoPlayer: player!)
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
}

