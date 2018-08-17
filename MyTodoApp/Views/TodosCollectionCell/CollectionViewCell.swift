//
//  CollectionViewCell.swift
//  YoutubeDemo
//
//  Created by Melanie on 8/14/18.
//  Copyright © 2018 DoApps. All rights reserved.
//

import UIKit
import SwiftyJSON

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var todoTitleLabel: UILabel!
  @IBOutlet weak var taskOneLabel: UILabel!
  @IBOutlet weak var taskTwoLabel: UILabel!
  @IBOutlet weak var taskThreeLabel: UILabel!
  @IBOutlet weak var taskFourLabel: UILabel!
  @IBOutlet weak var taskFiveLabel: UILabel!
  @IBOutlet weak var taskSixLabel: UILabel!
  @IBOutlet weak var taskOneButton: UIButton!
  @IBOutlet weak var taskTwoButton: UIButton!
  @IBOutlet weak var taskThreeButton: UIButton!
  @IBOutlet weak var taskFourButton: UIButton!
  @IBOutlet weak var taskFiveButton: UIButton!
  @IBOutlet weak var taskSixButton: UIButton!
  
  var tasksLayout: [(label: UILabel, button: UIButton)] = []
  var tasks: [Task] = []
  var isDone: Bool = Bool()
  var todo:  [Todo] = []
  var value: Int = Int()
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    tasksLayout.append((taskOneLabel, taskOneButton))
    tasksLayout.append((taskTwoLabel, taskTwoButton))
    tasksLayout.append((taskThreeLabel, taskThreeButton))
    tasksLayout.append((taskFourLabel, taskFourButton))
    tasksLayout.append((taskFiveLabel, taskFiveButton))
    tasksLayout.append((taskSixLabel, taskSixButton))
  }

  @IBAction func taskOneState(_ sender: UIButton) {
    value = 0
    changeState(button: sender,val: value)
    
  }
  @IBAction func taskTwoState(_ sender: UIButton) {
    value = 1
    changeState(button: sender,val: value)
    
  }
  @IBAction func taskThreeState(_ sender: UIButton) {
    value = 2
    changeState(button: sender,val: value)
    
  }
  @IBAction func taskFourState(_ sender: UIButton) {
    value = 3
    changeState(button: sender,val: value)
    
  }
  @IBAction func taskFiveState(_ sender: UIButton) {
    value = 4
    changeState(button: sender,val: value)
    
  }
  @IBAction func taskSixState(_ sender: UIButton) {
      value = 5
    changeState(button: sender,val: value)
  
  }
  
  func saveTodoChangeWith(task: Task, newisDone: Bool){
    TodoEndPoint.editTask(withUpdateTask: task, isDone: newisDone) { taskId, error in
      if let error = error {
        print(error)
        return
      }
      if let _ = taskId {
        DispatchQueue.main.async {
          print("")
        }
      }
    }
  }
 
  func getTask(task: [JSON]){
    tasks = Task.from(jsonArray: task)
    if tasks.count > 0{
      set(Tasks: tasks)
    }else{
      for taskLayout in tasksLayout{
        taskLayout.label.isHidden = true
        taskLayout.button.isHidden = true
      }
    }
  }
  
  func set(Tasks tasks: [Task]){

    for (index,taskLayout) in tasksLayout.enumerated(){
      if index >= tasks.count{
        break
      }
      taskLayout.label.isHidden = false
      taskLayout.button.isHidden = false
      taskLayout.label.text = tasks[index].title
      
      if tasks[index].isDone{
        taskLayout.button.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
      }else{
        taskLayout.button.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
      }
    }
  }
  
  func changeState (button: UIButton, val: Int) {
    if  button.currentImage == #imageLiteral(resourceName: "ic_checked") {
      button.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
      isDone = false
    }else {
      button.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
      isDone = true
   }
    saveTodoChangeWith(task: tasks[val], newisDone: isDone)
    
 }
}
