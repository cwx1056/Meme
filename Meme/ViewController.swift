//
//  ViewController.swift
//  Meme
//
//  Created by Tech Netaround on 4/4/17.
//
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeFromeKeyboardNotifications()
    }
    
    // MARK: -
    // MARK: Events reponse
    
    @IBAction func shareMemedImage(_ sender: Any) {
        // generate a memed image
        let memedImage = generateMemedImage()
        
        // define an instance of the ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activeType, completed, returnedItems, activityError in
            if completed {
                self.save(with: memedImage)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteMemedImage(_ sender: Any) {
    }

    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if let button = sender as? UIButton {
            switch button.tag {
            case 2:
                pickerController.sourceType = .camera
            default:
                pickerController.sourceType = .photoLibrary
            }
        }
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        let textField = (topTextField.isFirstResponder ? topTextField : bottomTextField)!
        let textFieldHeight = textField.frame.origin.y + textField.frame.height
        let keyboardY = view.frame.height - getKeyboardHeight(notification)
        
        if keyboardY < textFieldHeight {
            let offset = textFieldHeight - keyboardY + 10
            view.frame.origin.y = -offset
        }
        
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: -
    // MARK: Private methods
    
    fileprivate func setupTextFields() {
        setupTextField(topTextField)
        setupTextField(bottomTextField)
    }
    
    fileprivate func setupTextField(_ textField: UITextField) {
        let memeTextAttributes: [String: Any] = [NSStrokeColorAttributeName: UIColor.black,
                                                 NSStrokeWidthAttributeName: -2.0,
                                                 NSForegroundColorAttributeName: UIColor.white,
                                                 NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    fileprivate func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    fileprivate func unsubscribeFromeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func configureUI() {
        shareButtonItem.isEnabled = imageView.image != nil
        cancelButtonItem.isEnabled = false
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    fileprivate func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    fileprivate func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideToolbarAndNaviBar()
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar return
        showToolBarAndNaviBar()
        
        return memedImage
    }
    
    fileprivate func hideToolbarAndNaviBar() {
        navigationController?.navigationBar.isHidden = true
        toolBar.isHidden = true
    }
    
    fileprivate func showToolBarAndNaviBar() {
        navigationController?.navigationBar.isHidden = false
        toolBar.isHidden = false
    }
    
    fileprivate func save(with memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        originalImage: imageView.image!,
                        memedImage: memedImage)
    }
}

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            configureUI()
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        configureUI()
    }
    
}

extension ViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField == topTextField && text == "TOP" {
            textField.text = ""
        } else if textField == bottomTextField && text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
