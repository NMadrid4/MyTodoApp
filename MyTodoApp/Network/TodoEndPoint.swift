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
        Alamofire.request("\(TodoAPI.baseURL)\(TodoAPI.myTodosURL)").responseJSON { response in
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
          //  
            
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
    
}
