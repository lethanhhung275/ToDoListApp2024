//
//  Todo.swift
//  ToDoListApp2024
//
//  Created by Lê Hưng on 26/5/24.
//

import UIKit

class Todo {
    // MARK: Properties
    var titleTodo:String
    var descriptionTodo:String
    var timeTodo:String
    
    init?(titleTodo: String, descriptionTodo: String, timeTodo: String) {
        if titleTodo.isEmpty  {
            return nil
        }
        if descriptionTodo.isEmpty  {
            return nil
        }
        // Tao duoc doi tuong todo
        self.titleTodo = titleTodo
        self.descriptionTodo = descriptionTodo
        self.timeTodo = timeTodo
    }
}
