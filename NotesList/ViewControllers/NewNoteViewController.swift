//
//  NewNoteViewController.swift
//  NotesList
//
//  Created by Анастасия Конончук on 14.04.2024.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet private var newNoteTextView: UITextView!
    
    var note: String?
    var onNote: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       newNoteTextView.text = note
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        onNote?(newNoteTextView.text)
    }
}
