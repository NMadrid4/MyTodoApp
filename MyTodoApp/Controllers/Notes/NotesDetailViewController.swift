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
  
    var titleItem: String = "New note"
    var isExisted = false
    var note: Notes?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleItem
      
      if let note = note {
        descriptionTextView.text = note.description
      }
      if !isExisted {
        noteButton.setTitle("Create", for: .normal)
        noteButton.addTarget(self, action: #selector(createNote), for: .touchUpInside)
      }else{
        noteButton.setTitle("save Changes", for: .normal)
       // noteButton.addTarget(self, action: #selector(saveNotesChanges), for: .touchUpInside)
      }
    }

  @objc func createNote() {
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
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
