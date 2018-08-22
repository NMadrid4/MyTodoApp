//
//  TodoEndPoint.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 8/11/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TodoEndPoint {
    
  static func getTodos(completionHandler: @escaping(_ todos: [Todo]?, _ error: String?)-> Void){
      Alamofire.request("\(TodoAPI.baseURL)\(TodoAPI.todoWithTask)", method: .get, parameters: [:], encoding: URLEncoding.queryString).responseJSON { response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!) 
                completionHandler(Todo.from(jsonArray: data.array!),nil)
              
            case .failure(let error):
                print(error)
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
  
  static func edidTodo(withUpdateTodo updateTodo: Todo, completionHandler: @escaping(_ idTodo: String?, _ error: String?)-> Void){
      
        let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.modifyMyTodoUrl)", "\(updateTodo.id)")
          let params = ["title": updateTodo.title, "description": updateTodo.description]
        Alamofire.request(url, method: .put, parameters: params).responseJSON{ response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.dictionary!["id"]?.stringValue,nil)
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
  
    static func createTodo(withTodo todo: Todo, completionHandler: @escaping(_ idTodo: String?, _ error: String?) -> Void ){
        let url = "\(TodoAPI.baseURL)\(TodoAPI.myTodosURL)"
        let params = ["title": todo.title, "description": todo.description,
        "dateCreated": Date().description,"dateUpdated": Date().description,
        "isDeleted": true, "toDoUserId": "0"] as [String:Any]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON{ response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.dictionary!["id"]?.stringValue,nil)
                
            case .failure(let error):
                print(error)
                completionHandler(nil, error.localizedDescription)
            }
      }
    }
    
    static func delete(Todo todo: Todo, completionHandler: @escaping(_ idTodo: Int?, _ error: String?)->Void){
        let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.modifyMyTodoUrl)", "\(todo.id)")
        let params = ["id": todo.id]
        Alamofire.request(url, method: .delete, parameters: params).responseJSON { response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.dictionary!["count"]?.intValue, nil)
            case .failure(let error):
                print(error)
                completionHandler(nil,error.localizedDescription)
            }
        }
    }
 
    static func getTaksFrom(completionHandler: @escaping(_ tasks: [Task]?, _ error: String?)->Void){
      Alamofire.request("\(TodoAPI.baseURL)\(TodoAPI.myTaskUrl)", method: .get).responseJSON { response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!)
                completionHandler(Task.from(jsonArray: data.array!),nil)
            case .failure(let error):
                print(error)
                completionHandler(nil,error.localizedDescription)
            }
        }
    }
    
    static func createTask(Title title: String, fromTodo todo: Todo, completionHandler: @escaping(_ idTask: Int?, _ error: String?)->Void){
        let url = "\(TodoAPI.baseURL)\(TodoAPI.myTaskUrl)"
        let params = ["title": title,
                      "isDone": false,
                      "toDoId": todo.id] as [String : Any]
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            switch(response.result){
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.dictionary!["id"]?.intValue, nil)
            case .failure(let error):
                print(error)
                completionHandler(nil,error.localizedDescription)
            }
        }
    }
  
  static func editTask(withUpdateTask updateTask: Task, isDone: Bool, completionHandler: @escaping(_ idTask: String?, _ error: String?)-> Void){
    
    let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.modifyMyTaskUrl)", "\(updateTask.id)")
    let params = ["title": updateTask.title, "isDone": isDone, "toDoId": updateTask.todoId] as [String : Any]
    Alamofire.request(url, method: .put, parameters: params).responseJSON{ response in
      switch(response.result){
      case .success:
        let data = JSON(response.data!)
        completionHandler(data.dictionary!["id"]?.stringValue,nil)
      case .failure(let error):
        print(error)
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  static func getNotes(completionHandler: @escaping (_ notes:[Notes]?, _ error: String?) -> Void) {
    Alamofire.request("\(TodoAPI.baseURL)\(TodoAPI.notesURL)").responseJSON { (response) in
      switch  response.result {
      case .success:
        let data = JSON(response.data!)
        completionHandler(Notes.from(jsonArray: data.array!),nil)
      case .failure(let error):
        print(error)
        completionHandler(nil,error.localizedDescription)
      }
    }
  }
  
  static func createNotes(withNote note:Notes, completionHandler: @escaping(_ idNote: Int?, _ error: String?) -> Void) {
    let url = "\(TodoAPI.baseURL)\(TodoAPI.notesURL)"
    let params = ["description": note.description,
                  "toDoUserId": "0"] as [String: Any]
    Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
      switch response.result {
      case .success:
        let data = JSON(response.data!)
        completionHandler(data.dictionary!["id"]?.intValue, nil)
      case .failure(let error):
        print(error)
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  static func editNotes(withNote updateNote: Notes, completionHandler: @escaping(_ idNote: Int?, _ error: String?)->Void) {
    let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.modifyNote)","\(updateNote.id)")
    let params = ["description": updateNote.description] as [String: Any]
    Alamofire.request(url, method: .put, parameters: params).responseJSON { (response) in
      switch response.result {
      case .success:
        let data = JSON(response.data!)
        completionHandler(data.dictionary!["id"]?.intValue, nil)
      case .failure(let error):
        print(error)
        completionHandler(nil, error.localizedDescription)
      }
    }
  }
  
  static func loginUser(email: String, password: String, completionHandler: @escaping(_ idToken: String?, _ idUser: Int?, _ error: String?)->Void) {
    let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.todoUserLogin)")
    let params = ["email": email, "password": password] as [String:Any]
    Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
      switch response.result {
      case .success:
        let data = JSON(response.data!)
        completionHandler(data.dictionary!["id"]?.stringValue, data.dictionary!["userId"]?.intValue,nil)
      case .failure(let error):
        print(error)
        completionHandler(nil, nil, error.localizedDescription)
      }
    }
  }
  
  static func createUser(username: String, email: String, password: String,
                         completionHandler: @escaping(_ idUser: Int?, _ emailExists: String?, _ error: String?)->Void) {
    
    let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.todoUser)")
    let params = ["name": "string",
                  "realm": "string",
                  "username": username,
                  "email": email,
                  "password": password,
                  "emailVerified": true] as [String : Any]
    Alamofire.request(url, method: .post, parameters: params).responseJSON { (response) in
      switch response.result {
      case .success:
        let data = JSON(response.data!)
        completionHandler(data.dictionary!["id"]?.intValue, nil, nil)
        if let _ = data.dictionary!["error"]?.dictionaryValue  {
          let error = data.dictionary!["error"]!.dictionaryValue
          let details = error["details"]!.dictionaryValue
          let codes = details["codes"]!.dictionaryValue
          let value = codes["email"]!
          if value[0] == "uniqueness" {
            completionHandler(nil,"uniqueness", nil)
          }
        }
       
      case .failure(let error):
        print(error)
        completionHandler(nil,nil, error.localizedDescription)
      }
    }
    
    
    }
}
