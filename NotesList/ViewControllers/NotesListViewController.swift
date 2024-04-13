//
//  NotesListViewController.swift
//  NotesList
//
//  Created by Анастасия Конончук on 14.04.2024.
//

import UIKit

class NotesListViewController: UITableViewController {

    @IBOutlet var notesListTableView: UITableView!
    
    var notes: [String] = []
    private var activeNote: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notesListTableView.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        let note = notes[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = note
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        activeNote = indexPath.row
        
        performSegue(withIdentifier: "note", sender: note)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               notes.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newNoteVC = segue.destination as? NewNoteViewController else { return }
        newNoteVC.note = sender as? String
        newNoteVC.onNote = { [weak self] text in
            if let activeNote = self?.activeNote {
                self?.notes.remove(at: activeNote)
                
//                let nnn = Notes(text: text, date: Date(), id: UUID())
                self?.notes.insert(text, at: 0)
                self?.activeNote = nil
            } else {
                self?.notes.insert(text, at: 0)
            }
            
//            self?.notes.sort(<)
            self?.notesListTableView.reloadData()
        }
    }
    

    @IBAction func addNoteAction(_ sender: Any) {
        performSegue(withIdentifier: "note", sender: nil)
    }
}

//struct Notes {
//    let text: String
//    let date: Date
//    let id: UUID
//}
