//
//  NotesView.swift
//  AnoteApp
//
//  Created by Rafael VSM on 04/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
private let notesCellReuseIdentifier = "notesCellReuseIdentifier"
class NotesView: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var numberOfNotes: Int {
        get {
            return 0
        }
    }
    
    fileprivate func configureTableView() {
        let nib = UINib(nibName: "NotesCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: notesCellReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkICloud()
        renderNavigationBar()
        configureTableView()
        configureToolbar()
    }
    
    func configureToolbar()  {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let ok = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(handleOkToolbar))
        ok.tintColor = .eggYellow
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.text = "\(numberOfNotes) Notas"
        label.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        
        let toolbarTitle = UIBarButtonItem(customView: label)
        let cancel = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeButtonToolbar))
        cancel.tintColor = .eggYellow
        
        toolbar.setItems([ok,toolbarTitle,cancel], animated: false)
        
        view.addSubview(toolbar)
        
        toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleOkToolbar(_ action: UIBarButtonItem) {
        
    }
    @objc func handleComposeButtonToolbar(_ action: UIBarButtonItem) {
        NSLog("%@", "compose")
    }
    
    fileprivate func renderNavigationBar() {
        title = "Notas"
        
        let image = UIImage(named: "back_arrow")?.withRenderingMode(.alwaysTemplate)
        image?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        let backArrowButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBackArrow))
        backArrowButton.tintColor = .eggYellow
        navigationItem.leftBarButtonItem = backArrowButton
        
        let editButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(handleEditButton))
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.white
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        
        editButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.eggYellow, NSAttributedString.Key.shadow: shadow], for: .normal)
        navigationItem.rightBarButtonItem = editButton
    }
    @objc func handleBackArrow(_ sender: UIBarButtonItem) {
        print("back")
    }
    @objc func handleEditButton(_ sender: UIBarButtonItem) {
        print("edit")
    }
    
    fileprivate func checkICloud() {
        if !User.shared.hasSeenNotesView {
            let ac = UIAlertController(title: "Ative o iCloud", message: "Para acessar suas notas em todos os seus dispositivos, ative o iCloud para Anota", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Abrir configurações", style: .default, handler: openSettings))
            ac.addAction(UIAlertAction(title: "Agora não", style: .cancel, handler: notNow))
            
            present(ac, animated: true)
        }
    }
    @objc func notNow(action: UIAlertAction! = nil) {
        User.shared.updateFirstTimeAppearNotesView()
        User.shared.updateICloudSetup(false)
    }
    @ objc func openSettings(action: UIAlertAction! = nil) {
        print("open settings")
        User.shared.updateFirstTimeAppearNotesView()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NotesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notesCellReuseIdentifier, for: indexPath) as! NotesCell
        cell.textLabel?.text = "TEst"
        return cell
    }
    
    
}
