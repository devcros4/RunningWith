import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    
    /// func call when you select image in pelicule
    /// - Parameter image: image choice
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    /// present the pickerController on the view
    /// - Parameter sourceView: sourceview where you present
    public func present(from sourceView: UIView) {
        self.pickerController.sourceType = .photoLibrary
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
    /// func call when you select image in pelicule
    /// - Parameter image: image choice
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}
/// config of imagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {

    
    /// cancel func when you tap cancel button
    /// - Parameter picker: UIImagePickerController
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
