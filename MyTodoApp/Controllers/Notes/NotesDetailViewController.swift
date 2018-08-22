//
//  NotesDetailViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 21/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class NotesDetailViewController: UIViewController {

  
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var noteButton: UIButton!
  @IBOutlet weak var noteBarButton: UIBarButtonItem!
  
    var titleItem: String = "New note"
    var isExisted = false
    var note: Notes?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleItem
        noteBarButton.tintColor = UIColor.orange
      
      if let note = note {
        descriptionTextView.text = note.description
      }
      if !isExisted {
        
        let font = UIFont.systemFont(ofSize: 25)
        noteBarButton.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font], for: .normal)
        noteBarButton.title = "✓"
      }else{
        noteBarButton.title = "save"
      }
    }
  func create(text: String) {
    print(text)
  }

  @IBAction func noteAction(_ sender: Any) {
    if !isExisted {
      createNote()
    }else {
      updateNote()
    }
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    descriptionTextView.resignFirstResponder()
  }
  
  func updateNote() {
    let updateNote = Notes(id: note!.id, description: descriptionTextView.text)
    TodoEndPoint.editNotes(withNote: updateNote) { (idNote, error) in
      if let error = error {
        print(error)
        return
      }
      if let _ = idNote {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func createNote() {
    guard !descriptionTextView.text!.isEmpty else {
      return
    }
    let newNote = Notes(id: 0, description: descriptionTextView.text!)
    TodoEndPoint.createNotes(withNote: newNote) { (idNewNote, error) in
      if let error = error {
        print(error)
        return
      }
      if let _ = idNewNote {
        self.navigationController?.popViewController(animated: true)        
      }
    }
  }
  
  func saveNote() {
    
  }
}
