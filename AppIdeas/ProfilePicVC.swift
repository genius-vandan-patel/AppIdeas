//
//  ProfilePicVC.swift
//  AppIdeas
//
//  Created by Vandan Patel on 10/22/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfilePicVC: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var imageData: Data?
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTapGestureForProfilePic()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if InnovatorStorage.innovators[userID!]?.profilePicURL != nil {
            profilePicImageView.image = UIImage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageData == nil {
            if let profilePicURL = InnovatorStorage.innovators[userID!]?.profilePicURL {
                let url = URL(string: profilePicURL)
                profilePicImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Profile_Pic"), options: [.progressiveDownload, .continueInBackground], completed: { (image, error, _ , _) in
                    self.adjustRightBarButtonItem()
                })
            }
        }
    }
    
    func adjustRightBarButtonItem() {
        if profilePicImageView.image == #imageLiteral(resourceName: "Profile_Pic") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(didTapAdd(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEdit(_:)))
        }
    }
    
    func createTapGestureForProfilePic() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        tapGesture.numberOfTapsRequired = 1
        profilePicImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapProfilePic() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseStorage(data: Data, completion: @escaping (Bool)->()) {
        self.showActivityIndicator()
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let fullName = InnovatorStorage.innovators[userID!]?.fullName
        let storageRef = Storage.storage().reference(withPath: "\(userID!)\(fullName ?? "No Name")")
        
        storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            self.hideActivityIndicator()
            if error == nil {
                dataStorage.uploadProfilePicURLToFirebase(self.userID!, picURL: (metadata?.downloadURL()?.absoluteString)!, completion: {
                    if var innovator = InnovatorStorage.innovators[self.userID!] {
                        innovator.profilePicURL = metadata?.downloadURL()?.absoluteString
                        InnovatorStorage.innovators[self.userID!] = innovator
                    }
                    completion(true)
                })
            } else {
                print("There is an error : \(String(describing: error?.localizedDescription))")
                completion(false)
            }
        }
    }
    
    @objc func didTapAdd(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTapEdit(_ sender: UIButton) {
        presentActionSheet()
    }
    
    @objc func didTapSave(_ sender: UIButton) {
        uploadImageToFirebaseStorage(data: imageData!) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func presentActionSheet() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoGalleryAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .destructive) { (_) in
            InnovatorStorage.innovators[self.userID!]?.profilePicURL = nil
            //make firebase call for this action
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoGalleryAction)
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true) {}
    }
}

extension ProfilePicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave(_:)))
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicImageView.image = originalImage
            imageData = UIImageJPEGRepresentation(originalImage, 0.5)
        } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicImageView.image = editedImage
            imageData = UIImageJPEGRepresentation(editedImage, 0.5)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
