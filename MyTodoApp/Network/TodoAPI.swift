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
    
    static let baseURL = "http://192.168.1.29:3000/"
    static let myTodosURL = "api/ToDos"
    static let modifyMyTodoUrl = "api/ToDos/%@"

    
    static let todoTaskUrl = "api/ToDos/%@/tasks"
    static let myTaskUrl = "api/Tasks"
}
