//
//  MealPrepVC.swift
//  MyChef
//
//  Created by Ankit  Mane on 11/26/23.
//

import UIKit
import AWSRekognition

class MealPrepVC: UIViewController  & UINavigationControllerDelegate {
    
    var cameraImage = UIImageView()
    let titleLabel  = CustomTitleLabel(textAlignment: .center, fontSize: 20)
    var ingredientsSet = Set<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCameraImage()
        configureTitleLabel()
        
    }
    
    private func configureVC(){
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor  = .black
    }
    
    private func configureCameraImage(){
        view.addSubview(cameraImage)
        cameraImage.translatesAutoresizingMaskIntoConstraints = false
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        cameraImage.tintColor = .black
        cameraImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraImageClicked))
        cameraImage.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            cameraImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cameraImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraImage.widthAnchor.constraint(equalToConstant: 200),
            cameraImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    @objc func cameraImageClicked(){
//        openCamera()
        ingredientsSet.insert("Banana")
        ingredientsSet.insert("Egg")
        ingredientsSet.insert("Peanut Butter")
        ingredientsSet.insert("Milk")
        ingredientsSet.insert("Honey")
        ingredientsSet.insert("Baking Powder")

        let filterVC = AllFilterViewController()
        // TODO: change array to set
        filterVC.ingredients = Array(self.ingredientsSet).sorted { $0.count < $1.count }
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    private func openCamera(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                // Show an alert or handle the absence of a camera in some other way
                print("Camera is not available on this device.")
                return
            }

            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self // Make sure your class conforms to UIImagePickerControllerDelegate and UINavigationControllerDelegate
            self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.text = "To generate a recipe, please scan all the ingredients using your camera!"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .appDarkBrown
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cameraImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
        ])
    }
    

    
}

extension MealPrepVC : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Could not get JPEG representation of UIImage")
                return
            }
            self.sendImageToServer(imageData: imageData)
        }
    }


    func sendImageToServer(imageData: Data) {
        let rekognitionClient = AWSRekognition.default()
        let rekognitionImage = AWSRekognitionImage()
        rekognitionImage!.bytes = imageData

        let request = AWSRekognitionDetectLabelsRequest()
        request!.image = rekognitionImage
        request!.maxLabels = 20 // Adjust based on your needs
        request!.minConfidence = 80 // Adjust the confidence level based on your needs
        self.showLoadingView()
        rekognitionClient.detectLabels(request!) { [weak self] response, error in
            guard let self = self else { return }

            if let error = error {
                print("Failed to detect labels: \(error.localizedDescription)")
                self.dismissLoadingView()
                return
            }

            self.dismissLoadingView()

            guard let response = response else {
                print("No response from Rekognition service.")
                return
            }

            for label in response.labels ?? [] {
                if let name = label.name, let confidence = label.confidence {
                    print("Label: \(name), Confidence: \(confidence)%")
                    if IngredientsDataManager.shared.ingredientsSet.contains(name.lowercased()) {
                        self.ingredientsSet.insert(name)
                    }
                }
            }

            // Move the filterVC code inside the completion handler
            DispatchQueue.main.async {
                let filterVC = AllFilterViewController()
                filterVC.ingredients = Array(self.ingredientsSet).sorted()
                self.navigationController?.pushViewController(filterVC, animated: true)
            }
        }
    }


}
