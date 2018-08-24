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
  var userToken: String?
  var userId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userToken = UserData.sharedInstance.userToken
    userId = UserData.sharedInstance.idUser
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Notes", style: .plain, target: nil, action: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
  }
  
  func getData() {
    TodoEndPoint.getNotes(userToken: userToken!, idUser: userId!) { (notes, error) in
      guard error == nil, let notes = notes else {
        if let error = error {
          print(error)
        }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell")!
    let newStr = notes[indexPath.row].description
    if newStr.count > 32 {
      let noteString = newStr.prefix(30)
      cell.textLabel?.text  = noteString + "..."
    }else {
      cell.textLabel?.text = notes[indexPath.row].description
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let note = notes[indexPath.row]
    performSegue(withIdentifier: "notesDetail", sender: note)
    
  }
  
  
}
