//
//  ViewController.swift
//  ToDoListApp2024
//
//  Created by Lê Hưng on 26/5/24.
//

import UIKit

class AddTaskController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var todoTile: UITextField!
    @IBOutlet weak var todoDescription: UITextField!
    @IBOutlet weak var todoTime: UIDatePicker!
    @IBOutlet weak var navigation: UINavigationItem!
    
    // Dinh nghia bien meal dung de truyen qua lai giua man hinh A va B
    var todo:Todo?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Thuc hien uy quyen cho doi tuong
        todoTile.delegate = self
        todoDescription.delegate = self
        // Lay todo truyen tu man hinh A(TodoTableViewController) sang
        if let todo = todo {
            todoTile.text = todo.titleTodo
            todoDescription.text = todo.descriptionTodo
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM-dd-yyyy HH:mm"
            let date = dateFormatter.date(from: todo.timeTodo)
            todoTime.setDate(date!, animated: true)
            navigation.title = "Update Task"
        }
    }

    // MARK: Dinh nghia lai cac ham duoc uy quyen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // An ban phim
        todoTile.resignFirstResponder()
        todoDescription.resignFirstResponder()
        return true
    }
    
    // MARK: NAVIGATION
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // Ham tu dong goi moi khi chuyen man hinh voi doi tuong Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let title = todoTile.text ?? ""
        let description = todoDescription.text ?? ""
        let selectDate = todoTime.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: selectDate)
        todo = Todo(titleTodo: title, descriptionTodo: description, timeTodo: stringDate)
    }
    
}

