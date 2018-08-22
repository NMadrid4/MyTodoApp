//
//  TaskTableViewCell.swift
//  MyTodoApp
//
//  Created by Melanie on 8/17/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

  @IBOutlet weak var taskTitleLabel: UILabel!
  @IBOutlet weak var isDoneButton: UIButton!
  var taskId = 0
  var todoId = 0
  var isDone: Bool?
  
  override func awakeFromNib() {
        super.awakeFromNib()

  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  }
  
  func saveTodoChangeWith(task: Task, newisDone: Bool){
    TodoEndPoint.editTask(withUpdateTask: task, isDone: newisDone) { taskId, error in
      if let error = error {
        print(error)
        return
      }
      if let _ = taskId {
        DispatchQueue.main.async {
        }
      }
    }
  }
  
  @IBAction func changeState(_ sender: Any) {
    changeButtonState(button: isDoneButton)
    let newTask = Task(title: taskTitleLabel.text!, id: taskId, isDone: isDone!, todoId: todoId)
    saveTodoChangeWith(task: newTask, newisDone: isDone!)
  }
  
  func changeButtonState (button: UIButton) {
    if  isDoneButton.currentImage == #imageLiteral(resourceName: "ic_checked") {
      let attributedString = NSMutableAttributedString(string: taskTitleLabel.text!)
      attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, attributedString.length))
      taskTitleLabel.attributedText = attributedString
      taskTitleLabel.textColor = UIColor.black
      isDoneButton.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
      isDone = false
    }else {
      let attributedString = NSMutableAttributedString(string: taskTitleLabel.text!)
      attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
      taskTitleLabel.attributedText = attributedString
      taskTitleLabel.textColor = UIColor.gray
      isDoneButton.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
      isDone = true
    }
    
  }
}
