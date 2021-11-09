//
//  ViewController.swift
//  Text Fields
//
//  Created by Дмитрий Фетюхин on 28.10.2021.
//

import SafariServices
import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    
    //MARK: - Creating class instances
    private let noDigitsViewController = NoDigitsViewController()
    private let inputLimitViewController = InputLimitViewController()
    private let inputMaskViewController = InputMaskViewController()
    private let linkViewController = LinkViewController()
    private let passwordViewController = PasswordViewController()
    
    //MARK: - Standart values
    private let inputLimitNumber = 10
    private var timer: Timer?
    private let passwordFirstRuleNotChecked = "☑️ minimum of 8 characters."
    private let passwordFirstRuleChecked = "✅ minimum of 8 characters."
    private let passwordSecondRuleNotChecked = "☑️ minimum 1 digit."
    private let passwordSecondRuleChecked = "✅ minimum 1 digit."
    private let passwordThirdRuleNotChecked = "☑️ minimum 1 lowercased."
    private let passwordThirdRuleChecked = "✅ minimum 1 lowercased."
    private let passwordFourthRuleNotChecked = "☑️ minimum 1 uppercased."
    private let passwordFourthRuleChecked = "✅ minimum 1 uppercased."
    private let digits = Array("0123456789")
    private let lowercasedCharacters = Array("abcdefghijklmnopqrstuvwxyz")
    private let uppercasedCharacters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private var counterForDigits = 0
    private var counterForLowercased = 0
    private var counterForUppercased = 0
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noDigitsContainerView: UIView!
    @IBOutlet weak var inputLimitContainerView: UIView!
    @IBOutlet weak var inputMaskContainerView: UIView!
    @IBOutlet weak var linkContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var inputLimitLabel: UILabel!
    @IBOutlet weak var passwordFirstRuleLabel: UILabel!
    @IBOutlet weak var passwordSecondRuleLabel: UILabel!
    @IBOutlet weak var passwordThirdRuleLabel: UILabel!
    @IBOutlet weak var passwordFourthRuleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputLimitLabel.text = String(inputLimitNumber)
        
        passwordFirstRuleLabel.text = passwordFirstRuleNotChecked
        passwordSecondRuleLabel.text = passwordSecondRuleNotChecked
        passwordThirdRuleLabel.text = passwordThirdRuleNotChecked
        passwordFourthRuleLabel.text = passwordFourthRuleNotChecked
        
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
    
    deinit {
        removeKeyboardNotification()
    }
    
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
    
    //MARK: - textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == linkViewController.linkTextField {
            if linkViewController.linkTextField.text!.prefix(7) == "http://" || linkViewController.linkTextField.text!.prefix(8) == "https://" {
                showSafariVC()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK: - noDigits logic
        if textField == noDigitsViewController.noDigitsTextField {
            let notAllowedCharacters = "0123456789"
            let notAllowedCharacterSet = CharacterSet(charactersIn: notAllowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            if typedCharacterSet.isEmpty == false {
                if notAllowedCharacterSet.isSuperset(of: typedCharacterSet) == true {
                    return false
                }
            }
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
        if textField == inputMaskViewController.inputMaskTextField {
            if (textField.text?.count)! <= 5 {
                if (textField.text?.count)! == 4 {
                    perform(#selector(putADash), with: nil, afterDelay: 0.1)
                }
                let allowedCharacters = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"
                let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                let typedCharacterSet = CharacterSet(charactersIn: string)
                return allowedCharacterSet.isSuperset(of: typedCharacterSet)
            } else if (textField.text?.count)! >= 6 && (textField.text?.count)! <= 10 {
                let allowedCharacters = "0123456789"
                let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                let typedCharacterSet = CharacterSet(charactersIn: string)
                return allowedCharacterSet.isSuperset(of: typedCharacterSet)
            } else if (textField.text?.count)! > 10 {
                return false
            }
        }
        
        //MARK: - password logic
        if textField == passwordViewController.passwordTextField {
            perform(#selector(passwordSecondCheck), with: nil, afterDelay: 0.1)
            perform(#selector(passwordFirstCheck), with: nil, afterDelay: 0.1)
            perform(#selector(passwordThirdCheck), with: nil, afterDelay: 0.1)
            perform(#selector(passwordFourthCheck), with: nil, afterDelay: 0.1)
        }
        
        return true
    }

    @objc func putADash() {
        inputMaskViewController.inputMaskTextField.text = "\(inputMaskViewController.inputMaskTextField.text!)-"
    }
    
    func showSafariVC() {
        guard let url = URL(string: linkViewController.linkTextField.text!) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true)
    }
    
    @objc func passwordFirstCheck() {
        if (passwordViewController.passwordTextField.text?.count)! >= 8 {
            passwordFirstRuleLabel.text  = passwordFirstRuleChecked
            passwordFirstRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordFirstRuleLabel.text = passwordFirstRuleNotChecked
            passwordFirstRuleLabel.textColor = UIColor.darkGray
        }
    }
    
    @objc func passwordSecondCheck() {
        for i in Array(passwordViewController.passwordTextField.text!) {
            for j in digits {
                if i == j {
                    counterForDigits += 1
                }
            }
        }
        if counterForDigits >= 1 {
            passwordSecondRuleLabel.text  = passwordSecondRuleChecked
            passwordSecondRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordSecondRuleLabel.text = passwordSecondRuleNotChecked
            passwordSecondRuleLabel.textColor = UIColor.darkGray
        }
    }
    
    @objc func passwordThirdCheck() {
        for i in Array(passwordViewController.passwordTextField.text!) {
            for j in lowercasedCharacters {
                if i == j {
                    counterForLowercased += 1
                }
            }
        }
        if counterForLowercased >= 1 {
            passwordThirdRuleLabel.text  = passwordThirdRuleChecked
            passwordThirdRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordThirdRuleLabel.text = passwordThirdRuleNotChecked
            passwordThirdRuleLabel.textColor = UIColor.darkGray
        }
    }
    
    @objc func passwordFourthCheck() {
        for i in Array(passwordViewController.passwordTextField.text!) {
            for j in uppercasedCharacters {
                if i == j {
                    counterForUppercased += 1
                }
            }
        }
        if counterForUppercased >= 1 {
            passwordFourthRuleLabel.text  = passwordFourthRuleChecked
            passwordFourthRuleLabel.textColor = UIColor.systemGreen
        } else {
            passwordFourthRuleLabel.text = passwordFourthRuleNotChecked
            passwordFourthRuleLabel.textColor = UIColor.darkGray
        }
    }
    
}

