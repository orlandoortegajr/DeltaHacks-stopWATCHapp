//
//  DesignTextField.swift
//  stopWATCH
//
//  Created by Orlando Ortega on 2019-01-27.
//  Copyright © 2019 Orlando Ortega. All rights reserved.
//

import UIKit

@IBDesignable
class DesignTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            
            let width = leftPadding + 20
            
            
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width + 5, height: 20))
            view.addSubview(imageView)
            
            leftView = view
        } else {
            //image is nil
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [kCTForegroundColorAttributeName as NSAttributedString.Key : tintColor])
    }

}
