
//
//  NotesView.swift
//  AnoteApp
//
//  Created by Rafael VSM on 04/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import UIKit
private let notesCellReuseIdentifier = "notesCellReuseIdentifier"
class NotesView: UITableViewController {
    
    var notes = [Note]()
    
    var numberOfNotes: Int = 0 {
        didSet {
            for item in toolbarItems! {
                if item.accessibilityIdentifier == "tabnotas" {
                    let lb = item.customView as! UILabel
                    lb.text = "\(numberOfNotes) Notas"
                }
            }
        }
    }
    
    lazy var labelNotes: UILabel = {
        let lb = UILabel()
        lb.text = "\(numberOfNotes) Notas"
        lb.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.frame = CGRect(x: 0, y: 0, width: 200, height: 21)
        return lb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNotes()
    }
    func updateNotes() {
        if let savedData = User.shared.getUserNotes() {
            if let savedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Note] {
                self.notes = savedNotes
                numberOfNotes = notes.count
                tableView.reloadData()
            } else {
                print("failed to unarchive notes")
            }
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
        let ok = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(handleOkToolbar))
        ok.tintColor = .eggYellow
        
        let toolbarTitle = UIBarButtonItem(customView: labelNotes)
        toolbarTitle.accessibilityIdentifier = "tabnotas"
        let cancel = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeButtonToolbar))
        cancel.tintColor = .eggYellow
        let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [ok, flexible1 ,toolbarTitle, flexible2, cancel]
        
        navigationController?.isToolbarHidden = false
    }
    
    @objc func handleOkToolbar(_ action: UIBarButtonItem) {
        NSLog("%@", "folders media etc")
    }
    @objc func handleComposeButtonToolbar(_ action: UIBarButtonItem) {
        NSLog("%@", "compose")
        navigationController?.pushViewController(NoteView(nibName: "NoteView", bundle: .main), animated: true)
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
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleBackArrow(_ sender: UIBarButtonItem) {
        NSLog("%@", "backing")
        let controller = FolderNotesListView(style: .plain)
        navigationController?.pushViewController(controller, animated: true)
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
    
}
extension NotesView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notesCellReuseIdentifier, for: indexPath) as! NotesCell
        let selectedNote = notes[indexPath.row]
        cell.textLabel?.text = selectedNote.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        let controller = NoteView(nibName: "NoteView", bundle: .main)
        controller.note = selectedNote
        navigationController?.pushViewController(controller, animated: true)
    }
}
