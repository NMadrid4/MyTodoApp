//
//  NotesViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 21/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

  
  @IBOutlet weak var notesTableView: UITableView!
  
  var notes: [Notes] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
  }
  
  func getData() {
    TodoEndPoint.getNotes { (notes, error) in
      guard error == nil, let notes = notes else {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        self.notes = notes
        self.notesTableView.reloadData()
      }
    }
  }
  
  override func performSegue(withIdentifier identifier: String, sender: Any?) {
    if identifier == "notesDetail", let note = sender as? Notes{
        let noteDetail = storyboard?.instantiateViewController(withIdentifier: "notesDetailVC") as! NotesDetailViewController
        noteDetail.titleItem = "Edit Note"
        noteDetail.isExisted = true
        noteDetail.note = note
        self.navigationController?.pushViewController(noteDetail, animated: true)
    }
  }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell")
      cell?.textLabel?.text  = notes[indexPath.row].description
      return cell!
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let note = notes[indexPath.row]
    performSegue(withIdentifier: "notesDetail", sender: note)
    
  }
  
  
}
