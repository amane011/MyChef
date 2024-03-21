//
//  DietaryPreferenceCell.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/16/24.
//

import UIKit

class DietaryPreferenceCell: UICollectionViewCell {
    let pref = UILabel()
    let checkbox = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkbox)
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            checkbox.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            checkbox.heightAnchor.constraint(equalToConstant: 16),
            checkbox.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        pref.translatesAutoresizingMaskIntoConstraints = false;
        pref.textColor = .white
        pref.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(pref)
        
        NSLayoutConstraint.activate([
            pref.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 5),
            pref.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            pref.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            pref.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with preference: String, isSelected: Bool) {
        pref.text = preference
        checkbox.image = isSelected ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        checkbox.tintColor = .white
    }
}
