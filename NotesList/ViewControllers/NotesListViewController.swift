//
//  NotesListViewController.swift
//  NotesList
//
//  Created by Анастасия Конончук on 14.04.2024.
//

import UIKit

final class NotesListViewController: UITableViewController {

    @IBOutlet private var notesListTableView: UITableView!
    
    private let storageManager = StorageManager.shared
    private var activeNote: Int?
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notes = storageManager.fetchData(Note.self, sortKey: "date")
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
        content.text = note.text
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        activeNote = indexPath.row
        
        performSegue(withIdentifier: "note", sender: note.text)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               storageManager.delete(notes[indexPath.row])
               storageManager.saveContext()
               
               notes.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newNoteVC = segue.destination as? NewNoteViewController else { return }
        newNoteVC.note = sender as? String
        newNoteVC.onNote = { [weak self] text in
            guard let self = self else { return }
            
            let note = Note(context: self.storageManager.context)
            note.id = UUID()
            note.text = text
            note.date = Date()
            
            if let activeNote = self.activeNote {
                self.storageManager.delete(self.notes[activeNote])
                self.notes.remove(at: activeNote)
                self.activeNote = nil
            }
            
            self.storageManager.saveContext()
            self.notes.insert(note, at: 0)
            self.notesListTableView.reloadData()
        }
    }
    
    @IBAction func addNoteButtonPressed() {
        performSegue(withIdentifier: "note", sender: nil)
    }
}
