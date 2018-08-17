//
//  TodoAPI.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/28/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TodoAPI{
    
    static let baseURL = "http://localhost:3000/"
    static let myTodosURL = "api/ToDos"
    static let modifyMyTodoUrl = "api/ToDos/%@"
    static let todoWithTask = "api/ToDos?filter={\"include\":\"tasks\"}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    static let todoTaskUrl = "api/ToDos/%@/tasks"
    static let modifyMyTaskUrl = "api/Tasks/%@"
    static let myTaskUrl = "api/Tasks"
    static let notesURL = "api/Notes"
  
}
