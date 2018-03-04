//
//  SMPinManager.swift
//  SMPinSMS
//
//  Created by Santosh Maharjan on 2/4/18.
//  Copyright © 2018 Cyclone Nepal Info Tech. All rights reserved.
//  Santosh Maharjan
//  immortalsantee@me.com
//  www.santoshm.com.np

import UIKit

protocol SMPin {}
protocol SMPinTextFieldDeleteDelegate: class {
    func textFieldDidDelete(smPinTextField: SMPinTextField)
}
protocol SMPinViewDelegate: class {
    func textFieldIsTyping(smPinTextField: SMPinTextField)
}

/** Pin styled textfield. You can add additional feature if you want. */
class SMPinTextField: UITextField, SMPin {
    weak var deleteDelegate: SMPinTextFieldDeleteDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.textFieldDidDelete(smPinTextField: self)
    }
}

class SMPinButton: UIButton, SMPin {}

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
    
    fileprivate var smPinTextFields: [SMPinTextField]?
    weak var delegate: SMPinViewDelegate?
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
        let pinTFs = self.subviews.flatMap{$0 as? SMPin}
        pinTFs.forEach {
            if let smPinTF = $0 as? SMPinTextField {
                smPinTF.tintColor = .gray
                smPinTF.delegate = self
                smPinTF.deleteDelegate = self
                smPinTF.textAlignment = .center
                smPinTF.font = UIFont.systemFont(ofSize: self.fontSize)
                smPinTF.keyboardType = .numberPad
                smPinTF.addTarget(self, action: #selector(pinTFChanged), for: .editingChanged)
            }else if let smPinButton = $0 as? SMPinButton {
                smPinButton.addTarget(self, action: #selector(smPinButtonHandler), for: .touchUpInside)
            }
            
        }
        smPinTextFields = pinTFs.flatMap{$0 as? SMPinTextField}
    }
    
    @objc private func pinTFChanged(sender: SMPinTextField) {
        guard let smPinTFs = smPinTextFields else {return}
        
        /*  Get last character form the text typed by user.  */
        if let lastCharacter = (sender.text ?? "").last {
            let typedTextCount = Int(sender.text?.count ?? 0)
            
            if typedTextCount > 1 {
                /*  For current and next text fields  */
                let firstCharacter = (sender.text ?? "").first ?? " "
                sender.text = String(firstCharacter)
                
                if sender.tag < smPinTFs.count {
                    smPinTFs[sender.tag].becomeFirstResponder()
                    (smPinTFs[sender.tag]).text = String(lastCharacter)
                    
                    if sender.tag == smPinTFs.count - 1 {
                        self.endEditing(true)
                    }
                }else{
                    sender.resignFirstResponder()
                }
                delegate?.textFieldIsTyping(smPinTextField: sender)
                
                return
                
            }else{
                /*  For current text field only  */
                sender.text = String(lastCharacter)
            }
            
        }else{
            /*  Means user has pressed backspace so set empty string.  */
            sender.text = ""
            return
        }
        
        
        /*  Make sure the tag doesn't overflow the array index  */
        guard sender.tag < smPinTFs.count else {
            self.endEditing(true)
            return
        }
        if sender.text != "" {
            /*  Make sure user has typed something. And only make next textField first responder.  */
            smPinTFs[sender.tag].becomeFirstResponder()
        }
        
        delegate?.textFieldIsTyping(smPinTextField: sender)
    }
    
    @objc private func smPinButtonHandler(sender: SMPinButton) {
        guard let smPinTFs = smPinTextFields else {return}
        let activeTF = getActiveTextField() ?? smPinTFs.last
        activeTF?.deleteBackward()
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
     *  Return if all text fields are filled or not.
     */
    func isAllTextFieldTyped() -> Bool {
        guard let pinTFs = smPinTextFields else {return false}
        let filledValues = pinTFs.filter{!($0.text?.isEmpty ?? true)}
        return filledValues.count == pinTFs.count
    }
    
    /**
     *  Makes first SMPinTextField first responder.
     */
    func makeFirstTextFieldResponder() {
        smPinTextFields?.first?.becomeFirstResponder()
    }
    
    /**
     *  Ends all responder.
     */
    func resignAllResponder() {
        self.endEditing(true)
    }
    
    /**
     *  Clear all textFields
     */
    func clearAllText() {
        smPinTextFields?.forEach{ $0.text = ""}
    }
    
    /**
     *  Get active SMPinTextTield
     */
    func getActiveTextField() -> SMPinTextField? {
        return smPinTextFields?.filter{$0.isFirstResponder}.first
    }
    
}

extension SMPinView: SMPinTextFieldDeleteDelegate {
    func textFieldDidDelete(smPinTextField: SMPinTextField) {
        guard let smPinTFs = smPinTextFields else {return}
        
        let previousTag = smPinTextField.tag - 2
        smPinTFs[previousTag <= 0 ? 0 : previousTag].becomeFirstResponder()
        
        delegate?.textFieldIsTyping(smPinTextField: smPinTextField)
    }
    
}
