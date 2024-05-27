//
//  TodoTableViewController.swift
//  ToDoListApp2024
//
//  Created by Lê Hưng on 26/5/24.
//

import UIKit

class TodoTableViewController: UITableViewController {
    // MARK: Properties
    private var todos = [Todo]()
    private let addTaskID = "AddTask"
    private var selectedIndexPath:IndexPath?
    @IBOutlet weak var navigation: UINavigationItem!
    // Dinh nghia kieu du lieu enum de danh dau duong di
    enum NavigattionType {
        case addTask
        case updateTask
    }
    
    // Dinh nghia bien de danh dau duong di
    var navigationType:NavigattionType = .addTask
    
    //Tao doi tuong truy xuat CSDL
    private let dao = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Them edit button cho navigation
        navigation.leftBarButtonItem = editButtonItem
        
        //Doc toam bo meal tu CSDL (Neu co) va dua vao datasource
        dao.readAllTodos(todos: &todos)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "TodoCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TodoCell {
            // Lay du lieu tu datasource: todos
            let todo = todos[indexPath.row]
            // Do du lieu vao cell
            cell.todoTitle.text = todo.titleTodo
            cell.todoDescription.text = todo.descriptionTodo
            cell.todoTime.text = todo.timeTodo
            
            // Configure the cell...
            return cell
        }
        // Bao loi va dung chuong trinh
        fatalError("Khong the tao cell!!!")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //  Xoa todo trong datasource
            todos.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    // Bat su kien cho doi tuong Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tao doi tuong man hinh AddTaskConttroller
        if let addTask = self.storyboard!.instantiateViewController(withIdentifier: addTaskID) as? AddTaskController {
                    // Truyen todo tuong ung cho doi tuong man hinh AddTaskConttroller
                    addTask.todo = todos[indexPath.row]
                    // Danh dau duong di
                    navigationType = .updateTask
                    // Luu vi tri cell duoc chon
                    selectedIndexPath = indexPath
                    // Chuyen sang man hinh meal detail controller
                    present(addTask, animated: true)
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
     */
    
    @IBAction func newTask(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh AddTaskController
        let addTask = self.storyboard!.instantiateViewController(withIdentifier: addTaskID)
        // Danh dau duong di
        navigationType = .addTask
        // Chuyen sang man hinh AddTaskController
        present(addTask, animated: true)
    }
    
    // Dinh nghia ham unwind quay ve tu man hinh AddTaskController
    @IBAction func unwindFromAddTask(_ segue: UIStoryboardSegue) {
        // Lay doi tuong man hinh B (AddTaskController)
        if let addTask = segue.source as? AddTaskController {
            // Lay bien todo truyen ve
            if let todo = addTask.todo {
                switch(navigationType) {
                case .addTask:
                    // Them todo moi vao tableView
                    // B1: them todo moi vao datasource
                    todos.append(todo)
                    // B2: them todo vao tableView
                    let newIndexPath = IndexPath(row: todos.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    
                    //Ghi todo moi vao CSDL
                    let _ = dao.insertTodo(todo: todo)
                case .updateTask:
                    if let indexPath = selectedIndexPath {
                        // Cap nhat todo trong datasource
                        todos[indexPath.row] = todo
                        // Cap nhat todo tren tableView
                        tableView.reloadRows(at: [indexPath], with: .left)
                    }
                }
            }
        }
    }
    
}
