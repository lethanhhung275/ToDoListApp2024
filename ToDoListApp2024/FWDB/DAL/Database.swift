//
//  Database.swift
//  ToDoListApp2024
//
//  Created by Lê Hưng on 26/5/24.
//

import Foundation
import UIKit
import os.log

class Database {
    // MARK: Cac thuoc tinh chung cua CSDL
    private let DB_NAME = "todos.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    
    // MARK: Thuoc tinh cua cac bang du lieu
    //1. Bang meals
    private let TODO_TABLE_NAME = "todos"
    private let TODO_ID = "_id"
    private let TODO_TITLE = "title"
    private let TODO_DESCRIPTION = "description"
    private let TODO_TIME = "time"
    
    // MARK: Constructors
    init() {
        //Lay tat ca cac thu muc lien quan den document cua mot ung dung iOS
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //KHoi tao duong dan DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        //Khoi tao doi tuong CSDL
        database = FMDatabase(path: DB_PATH)
        //Kiem tra su thanh cong khi tao CSDL
        if database != nil {
            os_log("Khoi tao thanh cong CSDL!")
            //Tao cac bang du lieu o day
            // 1. Tao bang todos
            let sql = "CREATE TABLE \(TODO_TABLE_NAME)("
            + "\(TODO_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(TODO_TITLE) TEXT, "
            + "\(TODO_DESCRIPTION) TEXT, "
            + "\(TODO_TIME) TEXT)"
            let _ = tableCreate(sql: sql, tableName: TODO_TABLE_NAME)
        }
        else{
            os_log("Khoi tao khong thanh cong CSDL!")
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham primities cua CSDL
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 1. Mo CSDL
    private func open()->Bool {
        var OK = false
        if database != nil {
            if database!.open() {
                os_log("Mo CSDL thanh cong!!")
                OK = true
            }
            else{
                os_log("Mo CSDL khong thanh cong!!")
            }
        }
        return OK
    }
    
    // 2. Dong CSDL
    private func close() {
        if database != nil {
            database!.close()
        }
    }
    
    //3. Tao bang du lieu
    private func tableCreate(sql:String, tableName:String)->Bool {
        var OK = false
        if open() {
            if !database!.tableExists(tableName) {
                if database!.executeStatements(sql) {
                    os_log("Tao bang du lieu \(tableName) thanh cong!!")
                    OK = true
                }
                else{
                    os_log("Tao bang du lieu \(tableName) khong thanh cong!!")
                }
                //Dong CSDL
                close()
            }
        }
        return OK
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham APIs cua CSDL
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // 1. Them 1 todo vao CSDL
    func insertTodo(todo:Todo)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(TODO_TABLE_NAME) {
                // Cau lenh SQL
                let sql = "INSERT INTO \(TODO_TABLE_NAME)(\(TODO_TITLE), \(TODO_DESCRIPTION), \(TODO_TIME)) VALUES (?, ?, ?)"
                // Luu todo vao CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [todo.titleTodo, todo.descriptionTodo, todo.timeTodo]) {
                    os_log("Ghi todo \(todo.titleTodo) vao CSDL thanh cong!!")
                    OK = true
                }
                else {
                    os_log("Ghi todo \(todo.titleTodo) vao CSDL khong thanh cong!!")
                }
                
                //Dong CSDL
                close()
            }
        }
        return OK
    }
    
    //2. Doc toan bo todo tu CSDL ve datasource cua tableView
    func readAllTodos(todos: inout [Todo]) {
        if open() {
            if database!.tableExists(TODO_TABLE_NAME) {
                //khai bao bien luu ket qua doc CSDL
                var result:FMResultSet?
                //Cau lenh SQL
                let sql = "SELECT * FROM \(TODO_TABLE_NAME) ORDER BY \(TODO_ID) DESC"
                do {
                  result = try database!.executeQuery(sql, values: nil)
                }
                catch {
                    os_log("Khong the truy van CSDL!!")
                }
                
                // Doc du lieu tu result va tao cac todo moi
                if let result = result {
                    while result.next() {
                        let title = result.string(forColumn: TODO_TITLE) ?? ""
                        let description = result.string(forColumn: TODO_DESCRIPTION) ?? ""
                        let time = result.string(forColumn: TODO_TIME) ?? ""
                        //  Tao todo moi tu CSDL va dua vao datasource
                        if let todo = Todo(titleTodo: title, descriptionTodo: description, timeTodo: time){
                            todos.append(todo)
                        }
                    }
                }
                
                //Dong CSDL
                close()
            }
        }
    }
}
