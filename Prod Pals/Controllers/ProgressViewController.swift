//
//  ProgressViewController.swift
//  Prod Pals
//
//  Created by Shannon Brown on 2021-01-27.
//

import UIKit
import Firebase

class ProgressViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var progressImages: [UIImage] = []
    var imageUrls: [String] = []
    var selectedGoal: String?
    var user = Auth.auth().currentUser
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: ProgressCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadProgressPhotos()
        
    }
    
    @IBAction func addProgressClicked(_ sender: UIButton) {
        print("Add Progress Clicked")
        presentPicker()
    }
    

    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
//    private func createNewPhotosCollection(selectedGoal: String, imageUrls: [URL]) {
//        db.collection("goalProgress").addDocument(data: [
//            "goal" : selectedGoal,
//            "images": imageUrls
//        ])
//    }

    func loadProgressPhotos() {
        
        db.collection("goalProgress").addSnapshotListener { [self] (querySnapshot, error) in

            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {

                if let snapshotDocuments = querySnapshot?.documents {
                    
                    progressImages = []

                    for doc in snapshotDocuments {

                        let data = doc.data()
                        let currentGoal = selectedGoal!
                        
                        if let userData = data["user"] {
                            let userEmailString = userData as! String
                            
                            if userEmailString == user?.email! {
                                if let goalData = data["goal"] {
                                    let goalDataString = goalData as! String

                                    if goalDataString == currentGoal {

                                        let goalImageUrl = data["images"] as! String
                                        let url = URL(string: goalImageUrl)!

                                        URLSession.shared.dataTask(with: url) { (data, response, error) in

                                            if let data = data {
                                                progressImages.append(UIImage(data: data)!)
                                

                                                DispatchQueue.main.async() { [weak self] in
                                                            self?.collectionView.reloadData()
                                                        }

                                            } else {
                                                print(error!)
                                            }
                                        }.resume()

                                    }
                                }
                                
                            }
                        }

                    }

                }

            }
        }
    }
    
}


//MARK: - UICollectionView DataSource & Delegate Methods

extension ProgressViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progressImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
    
        cell.configure(with: progressImages[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected \(progressImages[indexPath.row])")
//
//    }


}

//MARK: - UIImagePickerController Delegate

extension ProgressViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imageSelectedFromPicker: UIImage?
        var currentSelectedGoal: String
        
        currentSelectedGoal = selectedGoal!
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM dd,yyyy"
        var todaysDate = dateFormatterGet.string(from: Date())
        print(todaysDate)

        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageSelectedFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSelectedFromPicker = originalImage
        }
        
        if let imageSelected = imageSelectedFromPicker {
//                                progressImages.append(imageSelected)
//                                collectionView.reloadData()
//                                print(progressImages)
            
                            let imageName = UUID().uuidString
        
                            let storageRef = Storage.storage().reference().child("goal_images").child("\(imageName).png")
        
                            if let uploadData = imageSelected.pngData() {
                                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
        
                                    storageRef.downloadURL { (url, error) in
                                        if error != nil {
                                            print(error!)
                                            return
                                        }
        
                                        guard let imageUrl = url else { return }
                                        self.createNewPhotosCollection(selectedGoal: currentSelectedGoal, imageUrlString: imageUrl.absoluteString, dateToday: todaysDate)

                                    }
        
                                }
                            }
        
                }

        picker.dismiss(animated: true, completion: nil)

    }
    
    func createNewPhotosCollection(selectedGoal: String, imageUrlString: String, dateToday: String) {
        
        if let userEmail = user?.email {
            db.collection("goalProgress").addDocument(data: [
                "goal" : selectedGoal,
                "user": userEmail,
                "images": imageUrlString,
                "date": dateToday
            ])
        }

    }
        
}

