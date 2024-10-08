//
//  File.swift
//  
//
//  Created by SY L on 8/6/24.
//

import Foundation

struct PingReq: Decodable {
    let value: String?
}

struct PingRes: Encodable {
    let value: String?
}

struct GetDbUserVersionRes: Encodable {
    let version: Int32?
}

struct GetAllTodoRes: Encodable {
    let todos: [Todo]
}

struct InsertTodoReq: Decodable {
    let todo: String
}

struct InsertTodoRes: Encodable {
    let rowid: Int64
}
