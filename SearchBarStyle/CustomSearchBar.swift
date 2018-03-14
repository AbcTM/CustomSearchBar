//
//  CustomSearchBar.swift
//  SearchBarStyle
//
//  Created by tlc on 2018/3/14.
//  Copyright © 2018年 tlc. All rights reserved.
//

import UIKit

enum CustomSearchBarPlaceHolderPosition {
    case left
    case center
    case right
}

@IBDesignable
class CustomSearchBar: UISearchBar, UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var iconSpacing: CGFloat = 10 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var searchIconW: CGFloat = 20 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var placeHolderFont: CGFloat = 15 {
        didSet {
            layoutSubviews()
        }
    }
    
    
    private var placeholderWidth: CGFloat {
        var width: CGFloat = 0
        
        if let placeholder = self.placeholder  {
            width = (placeholder as NSString).boundingRect(with: CGSize(width: 1000.0, height: 1000.0), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: placeHolderFont)], context: nil).size.width
        }
        width = width + iconSpacing + searchIconW
        return width
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutSubviews()
    }
    
    // MARK: - Events
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var result = true
        
        if let delegate = self.delegate, delegate.responds(to: #selector(delegate.searchBarShouldBeginEditing(_:))) {
            result = delegate.searchBarShouldBeginEditing!(self)
        }
        
        if #available(iOS 11.0, *) {
            self.setPositionAdjustment(UIOffset.zero, for: UISearchBarIcon.search)
            
        }
        return result
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        var result = true
        
        if let delegate = self.delegate, delegate.responds(to: #selector(delegate.searchBarShouldEndEditing(_:))) {
            result = delegate.searchBarShouldEndEditing!(self)
        }
        
        if #available(iOS 11.0, *) {
            self.setPositionAdjustment(UIOffset.init(horizontal: (textField.frame.size.width-placeholderWidth)/2, vertical: 0), for: UISearchBarIcon.search)

        }
        return result
    }
    
    // MARK: - UI
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let zSubView = self.subviews.last else {
            return
        }
        
        for subView in zSubView.subviews {
            print(subView.debugDescription)
            
            if subView.isKind(of: UITextField.self) {
                let textField = subView as! UITextField
                
                // 改变field的frame
                textField.frame = CGRect.init(x: 15.0, y: 7.5, width: self.frame.size.width - 30.0, height: self.frame.size.height-15.0)
                textField.backgroundColor = UIColor.orange
                textField.textColor = UIColor.white
                
                textField.borderStyle = .none
                textField.layer.cornerRadius = 5
                textField.layer.masksToBounds = true
                
                // 设置占位文字字体颜色
                textField.setValue(UIColor.init(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1), forKeyPath: "_placeholderLabel.textColor") //
                textField.setValue(UIFont.systemFont(ofSize: placeHolderFont), forKeyPath: "_placeholderLabel.font")
                
                if #available(iOS 11.0, *) {
                    self.setPositionAdjustment(UIOffset.init(horizontal: (textField.frame.size.width-placeholderWidth)/2, vertical: 0), for: UISearchBarIcon.search)
                    
                }
                
            }
        }
    }
}
