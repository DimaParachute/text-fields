//
//  ViewController.swift
//  Text Fields
//
//  Created by Дмитрий Фетюхин on 28.10.2021.
//

import SafariServices
import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    
//--------------------------------------------------------------------------
    
    //MARK: - Creating class instances
    private let noDigitsViewController = NoDigitsViewController()
    private let inputLimitViewController = InputLimitViewController()
    private let inputMaskViewController = InputMaskViewController()
    private let linkViewController = LinkViewController()
    private let passwordViewController = PasswordViewController()
    private let passwordRuleChecker = PasswordRuleChecker()
    private let inputMaskChecker = InputMaskChecker()
    private let urlValidation = URLValidation()
    
    //MARK: - Default values
    private let inputLimitNumber = 10
    private var timer: Timer?
    private let dashIndex = 5
    let passwordMinLengthRuleNotChecked = "☑️ minimum of 8 characters."
    let passwordMinLengthRuleChecked = "✅ minimum of 8 characters."
    let passwordDigitRuleNotChecked = "☑️ minimum 1 digit."
    let passwordDigitRuleChecked = "✅ minimum 1 digit."
    let passwordLowercasedRuleNotChecked = "☑️ minimum 1 lowercased."
    let passwordLowercasedRuleChecked = "✅ minimum 1 lowercased."
    let passwordUppercasedRuleNotChecked = "☑️ minimum 1 uppercased."
    let passwordUppercasedRuleChecked = "✅ minimum 1 uppercased."
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noDigitsContainerView: UIView!
    @IBOutlet weak var inputLimitContainerView: UIView!
    @IBOutlet weak var inputMaskContainerView: UIView!
    @IBOutlet weak var linkContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var inputLimitLabel: UILabel!
    @IBOutlet weak var passwordMinLengthRuleLabel: UILabel!
    @IBOutlet weak var passwordDigitRuleLabel: UILabel!
    @IBOutlet weak var passwordLowercasedRuleLabel: UILabel!
    @IBOutlet weak var passwordUppercasedRuleLabel: UILabel!
    
//--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputLimitLabel.text = String(inputLimitNumber)
        
        passwordMinLengthRuleLabel.text = passwordMinLengthRuleNotChecked
        passwordDigitRuleLabel.text = passwordDigitRuleNotChecked
        passwordLowercasedRuleLabel.text = passwordLowercasedRuleNotChecked
        passwordUppercasedRuleLabel.text = passwordUppercasedRuleNotChecked
        
        
        // MARK: - Adding subviews
        self.noDigitsContainerView.addSubview(noDigitsViewController.view)
        self.inputLimitContainerView.addSubview(inputLimitViewController.view)
        self.inputMaskContainerView.addSubview(inputMaskViewController.view)
        self.linkContainerView.addSubview(linkViewController.view)
        self.passwordContainerView.addSubview(passwordViewController.view)
        
        noDigitsViewController.noDigitsTextField.delegate = self
        inputLimitViewController.inputLimitTextField.delegate = self
        inputMaskViewController.inputMaskTextField.delegate = self
        linkViewController.linkTextField.delegate = self
        passwordViewController.passwordTextField.delegate = self
        
        registerForKeyboardNotifications()
        
    }
    
//--------------------------------------------------------------------------
    
    deinit {
        removeKeyboardNotification()
    }
    
    //Methods that make keyboard interact with UIScrollView
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
//--------------------------------------------------------------------------
    
    //MARK: - textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == linkViewController.linkTextField {
            if urlValidation.urlIsValidated(linkViewController.linkTextField.text!) {
                showSafariVC()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK: - noDigits logic
        if textField == noDigitsViewController.noDigitsTextField {
            return digitFilter(string: string)
        }
        
        //MARK: - inputLimit logic
        if textField == inputLimitViewController.inputLimitTextField {
            let newLength = textField.text!.count + string.count - range.length
            inputLimitLabel.text = String(inputLimitNumber - newLength)
            if (inputLimitNumber - newLength) < 0 {
                inputLimitLabel.textColor = UIColor.red
                inputLimitViewController.inputLimitTextField.layer.borderColor = UIColor.red.cgColor
                inputLimitViewController.inputLimitTextField.layer.borderWidth = 1
            } else {
                inputLimitLabel.textColor = UIColor.black
                inputLimitViewController.inputLimitTextField.layer.borderWidth = 0
            }
        }
        
        //MARK: - inputMask logic
        if textField == inputMaskViewController.inputMaskTextField && string.isEmpty == false {
            if inputMaskViewController.inputMaskTextField.text!.count == dashIndex {
                putADash()
            }
            return inputMaskChecker.inputMaskRulesFollowed(inputCharacter: string, sourceString: textField.text!)
        }
        
        //MARK: - password logic
        if textField == passwordViewController.passwordTextField {
            perform(#selector(passwordRulesCheckedOrNot), with: nil, afterDelay: 0.1)
        }
        
        return true
    }

//--------------------------------------------------------------------------
    
    //Method that contains every password rule methods and changes the text when any rule checked
    @objc func passwordRulesCheckedOrNot() {
        if passwordRuleChecker.minLengthRuleFollowed(string: passwordViewController.passwordTextField.text!) == true {
            passwordMinLengthRuleLabel.text = passwordMinLengthRuleChecked
            passwordMinLengthRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordMinLengthRuleLabel.text = passwordMinLengthRuleNotChecked
            passwordMinLengthRuleLabel.textColor = UIColor.darkGray
        }
        if passwordRuleChecker.atLeastOneDigitRuleFollowed(string: passwordViewController.passwordTextField.text!) == true {
            passwordDigitRuleLabel.text = passwordDigitRuleChecked
            passwordDigitRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordDigitRuleLabel.text = passwordDigitRuleNotChecked
            passwordDigitRuleLabel.textColor = UIColor.darkGray
        }
        if passwordRuleChecker.atLeastOneLowercasedRuleFollowed(string: passwordViewController.passwordTextField.text!) == true {
            passwordLowercasedRuleLabel.text = passwordLowercasedRuleChecked
            passwordLowercasedRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordLowercasedRuleLabel.text = passwordLowercasedRuleNotChecked
            passwordLowercasedRuleLabel.textColor = UIColor.darkGray
        }
        if passwordRuleChecker.atLeastOneUppercasedRuleFollowed(string: passwordViewController.passwordTextField.text!) == true {
            passwordUppercasedRuleLabel.text = passwordUppercasedRuleChecked
            passwordUppercasedRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordUppercasedRuleLabel.text = passwordUppercasedRuleNotChecked
            passwordUppercasedRuleLabel.textColor = UIColor.darkGray
        }
    }
    
    //We call this method to put a dash into string to separate letters and digits
    @objc func putADash() {
        inputMaskViewController.inputMaskTextField.text = "\(inputMaskViewController.inputMaskTextField.text!)-"
    }
    
    //Convert string with digits into string without digits for noDigits textField
    func digitFilter(string: String) -> Bool {
        let notAllowedCharacterSet = CharacterSet.decimalDigits
        let typedCharacterSet = CharacterSet(charactersIn: string)
        if typedCharacterSet.isEmpty == false {
            if notAllowedCharacterSet.isSuperset(of: typedCharacterSet) == true {
                return false
            }
        }
        return true
    }
    
    //Link opening in safari method
    func showSafariVC() {
        guard let url = URL(string: linkViewController.linkTextField.text!) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true)
    }

}

