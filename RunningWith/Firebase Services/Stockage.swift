import UIKit
import FirebaseStorage
/// class for save image in bdd
class Stockage {
    
    /// add image in bdd with reference in key
    /// - Parameters:
    ///   - reference: key of data
    ///   - data: data to save
    ///   - completion: reponse of the request true or false and url of data if its true and error message if its false
    func addImage(reference: StorageReference, data: Data, completion: SuccessCompletion?) {
        
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
