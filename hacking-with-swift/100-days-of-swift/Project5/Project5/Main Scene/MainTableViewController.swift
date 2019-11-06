//
//  MainTableViewController.swift
//  Project5
//
//  Created by rafaeldelegate on 10/12/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

struct GameState: Codable {
    
    var selectedWord: String
    var usedWords: [String]
}

class MainTableViewController: UITableViewController {
    // MARK: - Constants
    
    // MARK: - Variables
    var allWords = [String]()
    var usedWords = [String]()
    var gameState: GameState!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(resetGame))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["Ay ay muchacho"]
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        startGame()
        
    }
    
    @objc func startGame(_ sender: UIBarButtonItem? = nil) {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "gameState") as? Data {
            let jsonDecoder = JSONDecoder()
            if let decodedGameState = try? jsonDecoder.decode(GameState.self, from: savedData) {
                gameState = decodedGameState
                title = gameState.selectedWord
                usedWords = gameState.usedWords
                print(gameState.usedWords)
                tableView.reloadData()
            }
        } else {
            resetGame()
        }
        
        
        
    }
    func save() {
        print("vo salva")
        let defaults = UserDefaults.standard
        
        let jsonEncoder = JSONEncoder()
        
        if let dataToSave = try? jsonEncoder.encode(gameState) {
            defaults.set(dataToSave, forKey: "gameState")
        } else {
            print("failed to save")
        }
    }
    @objc func resetGame(_ sender: UIBarButtonItem? = nil) {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        gameState = GameState(selectedWord: title!, usedWords: usedWords)
        tableView.reloadData()
        save()
    }
    @objc func promptForAnswer(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField { (text) in
            print(text.text!)
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    func submit(_ answer: String) {
        
        let lowerAnswer = answer.lowercased()
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(lowerAnswer, at: 0)
                    gameState.usedWords = usedWords
                    save()
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    showError("Word not recognized", "You can't just make them up, you know")
                }
            } else {
                showError("Word already use", "Be more Original")
            }
        } else {
            guard let title = title else { return }
            showError("Word not possible ", "You can't spell that word from \(title.lowercased()).")
        }
    }
    
    func showError(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        
        guard var tempWord = title?.lowercased() else { return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                print(position)
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usedWords.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)

        cell.textLabel?.text = usedWords[indexPath.row]

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
