//
//  CustomTitleLabel.swift
//  MyChef
//
//  Created by Ankit  Mane on 2/23/24.
//



import UIKit

class CustomTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    init(textAlignment: NSTextAlignment, fontSize: CGFloat){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    func configure(){
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
