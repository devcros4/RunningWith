//
//  Stockage.swift
//  CodaGram
//
//  Created by Matthieu PASSEREL on 19/01/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit
import FirebaseStorage

class Stockage {
    
    func ajouterPostImage(reference: StorageReference, data: Data, completion: SuccessCompletion?) {
        
        reference.putData(data, metadata: nil) { (meta, error) in
            if error == nil {
                reference.downloadURL(completion: { (url, error) in
                    if error == nil, let urlString = url?.absoluteString {
                        completion?(true, urlString)
                    } else {
                        completion?(false, error?.localizedDescription)
                    }
                })
            } else {
                completion?(false, error!.localizedDescription)
            }
        }
    }
    
    
    
}
