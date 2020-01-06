//
//  NoteView.swift
//  AnoteApp
//
//  Created by Rafael VSM on 05/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit

class NoteView: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var note: Note!
    
    lazy var picker: UIImagePickerController = {
       let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    fileprivate func renderNavigationBar() {
        let backArrowImage = UIImage(named: "back_arrow")
        let backArrow = UIBarButtonItem(image: backArrowImage, style: .plain, target: self, action: #selector(handleBackArrowTapped))
        backArrow.tintColor = .eggYellow
        
        let notesButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(handleBackArrowTapped))
        notesButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.eggYellow], for: .normal)
        navigationItem.leftBarButtonItems = [backArrow, notesButton]
        
        let ok = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(handleOkButtonTapped))
        ok.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.eggYellow], for: .normal)
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShareButtonTapped))
        share.tintColor = .eggYellow
        navigationItem.rightBarButtonItems = [ok, share]
    }
    
    fileprivate func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.keyboardDismissMode = .interactive
        setupNotifications()
        renderNavigationBar()
        renderToolbar()
        textView.scrollIndicatorInsets = textView.contentInset
        if note != nil {
            textView.attributedText = note.textAttributed
        }
    }
    
    func renderToolbar() {
        let trashImage = UIImage(named: "trash")
        let trashButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(handleTrashTapped))
        trashButton.tintColor = .eggYellow
        
        let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let successImage = UIImage(named: "success")
        let successButton = UIBarButtonItem(image: successImage, style: .plain, target: self, action: #selector(handleSuccessButtonTapped))
        successButton.tintColor = .eggYellow
        
        let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cameraImage = UIImage(named: "camera")
        let cameraButton = UIBarButtonItem(image: cameraImage, style: .plain, target: self, action: #selector(handleCameraTapped))
        cameraButton.tintColor = .eggYellow
        
        let flexible3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let scribbleImage = UIImage(named: "scribble")
        let scribbleButton = UIBarButtonItem(image: scribbleImage, style: .plain, target: self, action: #selector(handleScribbleButtonTapped))
        scribbleButton.tintColor = .eggYellow
        
        let flexible4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeButtonTapped))
        compose.tintColor = .eggYellow
        
        toolbarItems = [trashButton, flexible1, successButton, flexible2, cameraButton, flexible3,  scribbleButton, flexible4, compose]
    }
    @objc func handleComposeButtonTapped(_ sender: UIBarButtonItem) {
        print("compose")
    }
    @objc func handleScribbleButtonTapped(_ sender: UIBarButtonItem) {
        print("scribble")
    }
    @objc func handleSuccessButtonTapped(_ sender: UIBarButtonItem) {
        print("success")
    }
    @objc func handleTrashTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Are you sure to delete this note?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: deleteNote))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    func deleteNote(action: UIAlertAction! = nil) {
        guard note != nil else {
            textView.text = ""
            return }
        
        if let savedNotes = getNotes() {
            var notes = savedNotes
            notes.removeAll { (savedNote) -> Bool in
                if (note.title == savedNote.title) {
                    return true
                }
                return false
            }
            save(notes)
            textView.text = ""
        } else {
            textView.text = ""
        }
    }
    @objc func handleCameraTapped(_ sender: UIBarButtonItem) {
        NSLog("%@", "???")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        }
        
        present(picker, animated: true) {
            //
        }
    }
    @objc func handleBackArrowTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @objc func handleOkButtonTapped(_ sender: UIBarButtonItem) {
        guard textView.text != nil, textView.text != "", let _ = textView.text else { return }
        note = Note( UUID().uuidString ,textView.attributedText)
        if let savedNotes = getNotes() {
            var notes = savedNotes
            notes.removeAll { (savedNote) -> Bool in
                if savedNote.textAttributed.string == note.textAttributed.string {
                    return true
                } else {
                    return false
                }
            }
            notes.append(note)
            save(notes)
        } else {
            save([note])
        }
    }
    func save(_ notes: [Note]) {
        if #available(iOS 11.0, *) {
            if let dataToSave = try? NSKeyedArchiver.archivedData(withRootObject: notes, requiringSecureCoding: false) {
                User.shared.saveUserNotes(dataToSave)
            } else {
                print("failed to archuve")
            }
        } else {
            let dataToSave = NSKeyedArchiver.archivedData(withRootObject: notes)
            User.shared.saveUserNotes(dataToSave)
        }
    }
    func getNotes() -> [Note]? {
        if let savedData = User.shared.getUserNotes() {
            if let savedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Note] {
                return savedNotes
            } else {
                print("failed to unarchive notes")
                return nil
            }
        }
        return nil
    }
    @objc func handleShareButtonTapped(_ sender: UIBarButtonItem) {
        NSLog("%@", "Share")
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenFrame = keyboardValue.cgRectValue
        let keyboardEndViewFrame = view.convert(keyboardScreenFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentSize = .zero
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndViewFrame.height, right: 0)
        }
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
extension NoteView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let atributedString = NSMutableAttributedString(string: "\n")
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        
        guard let oldImageWidth = textAttachment.image?.size.width else { print("no image size"); return }
        let scaleFactor = oldImageWidth / (textView.frame.width - (textView.frame.width / 2))
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
        atributedString.append(attributedStringWithImage)
        atributedString.append(NSAttributedString(string: "\n"))
        textView.attributedText = atributedString
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
