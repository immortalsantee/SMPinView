//
//  SMPinManager.swift
//  SMPinSMS
//
//  Created by Santosh Maharjan on 2/4/18.
//  Copyright © 2018 Cyclone Nepal Info Tech. All rights reserved.
//

import UIKit

/** Pin styled textfield. You can add additional feature if you want. */
class SMPinTextField: UITextField {}

/**
 1. Create UIView in storyboard.
 2. Assign **SMPinView** to it.
 3. Now add textfields as much you want for your app.
 4. Order you textfields in ascending order and assign tags from **Attribute Inspector**.
 5. Get your value with `getPinViewText()` method.
 6. That's it. 👍
 */
class SMPinView: UIView, UITextFieldDelegate {
    
    //MARK:- Properties
    
    private var smPinTextFields: [SMPinTextField]?
    @IBInspectable public var fontSize: CGFloat = 30
    
    
    //MARK:- Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setNecessaryDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setNecessaryDelegate()
    }
    
    
    
    //MARK:- Overrides
    
    override public func layoutSubviews() {
        /*  User can update */
        setNecessaryDelegate()
        
        super.layoutSubviews()
    }
    
    
    
    //MARK:- Private Helper Methods
    
    private func setNecessaryDelegate() {
        let pinTFs = self.subviews.flatMap{$0 as? SMPinTextField}
        pinTFs.forEach {
            $0.delegate = self
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: self.fontSize)
            $0.keyboardType = .numberPad
            $0.addTarget(self, action: #selector(pinTFChanged), for: .editingChanged)
        }
        smPinTextFields = pinTFs
    }
    
    @objc private func pinTFChanged(sender: SMPinTextField) {
        guard let smPinTFs = smPinTextFields else {return}
        
        /*  Get last character form the text typed by user.  */
        if let lastCharacter = (sender.text ?? "").last {
            sender.text = String(lastCharacter)
        }else{
            /*  Means user has pressed backspace so set empty string.  */
            sender.text = ""
        }
        
        /*  Make sure the tag doesn't overflow the array index  */
        guard sender.tag < smPinTFs.count else {
            sender.resignFirstResponder()
            return
        }
        if sender.text != "" {
            /*  Make sure user has typed something. And only make next textField first responder.  */
            smPinTFs[sender.tag].becomeFirstResponder()
        }
        
    }
    
    
    
    //MARK:- Public Helper Methods
    
    /**
     *  Returns string of current text fields
     */
    func getPinViewText() -> String {
        guard let pinTFs = smPinTextFields else {return ""}
        let value = pinTFs.reduce("", {$0 + ($1.text ?? "")})
        return value
    }
    
    /**
     *  Makes first SMPinTextField first responder.
     */
    func makeFirstTextFieldResponder() {
        smPinTextFields?.first?.becomeFirstResponder()
    }
    
    /**
     *  Clear all textFields
     */
    func clearAllText() {
        smPinTextFields?.forEach{ $0.text = ""}
    }
    
    
}
