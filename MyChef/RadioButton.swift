//
//  RadioButton.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/15/24.
//

import UIKit

class RadioButton: UIButton {

    let selectedImage = UIImage(systemName: "largecircle.fill.circle")
    let deselectedImage = UIImage(systemName: "circle")
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           initialize()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           initialize()
       }
       
       private func initialize() {
           self.setImage(deselectedImage, for: .normal)
           self.setTitleColor(.black, for: .normal)
           self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
           self.tintColor = .black
           self.imageView?.contentMode = .scaleAspectFit
           self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
           self.imageView?.translatesAutoresizingMaskIntoConstraints = false
       }
       
       @objc private func buttonTapped() {
           isSelected = !isSelected
       }
       
       override var isSelected: Bool {
           didSet {
               self.setImage(isSelected ? selectedImage : deselectedImage, for: .normal)
           }
       }

}
