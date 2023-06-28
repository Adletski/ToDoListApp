//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import XCTest
@testable import ToDoListApp

final class ToDoListAppTests: XCTestCase {
    
    private var item: ToDoItem?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        item = ToDoItem(id: "1", text: "adlet", importance: .usual, deadline: .now+100, isDone: false, createdAt: .now-100, modifiedAt: .now)
    }
    
    override func tearDownWithError() throws {
        item = nil
    }
    
    func testParsing() throws {
        
        guard let item = item else {
            XCTFail("item not filled")
            return
        }
        
        let json = item.json
        guard let parsedItem = ToDoItem.parse(json: json) else {
            XCTFail("item not parsed")
            return
        }
        
        XCTAssertEqual(item.id, parsedItem.id)
        XCTAssertEqual(item.text, parsedItem.text)
        XCTAssertEqual(item.importance, parsedItem.importance)
        XCTAssertEqual(item.isDone, parsedItem.isDone)
    }
    
    func testToDoItemInitialization() {
        
        let id = UUID().uuidString
        let text = "купить помидоры"
        let importance = ToDoItem.Importance.important
        let deadline = Date(timeIntervalSinceNow: 60*60*24)
        let isDone = false
        let createdAt = Date()
        
        
        let toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: isDone, createdAt: createdAt)
        
        
        XCTAssertEqual(toDoItem.id, id)
        XCTAssertEqual(toDoItem.text, text)
        XCTAssertEqual(toDoItem.importance, importance)
        XCTAssertEqual(toDoItem.deadline, deadline)
        XCTAssertEqual(toDoItem.isDone, isDone)
        XCTAssertEqual(toDoItem.createdAt, createdAt)
        XCTAssertNil(toDoItem.modifiedAt)
    }
    
    func testFileCacheAddItem() {
        let item = ToDoItem(id: "1", text: "adlet", importance: .important, deadline: .now, isDone: true, createdAt: .now, modifiedAt: .now)
        let file = FileCache()
        
        file.addItem(item)
        
        XCTAssertEqual(item.id, file.items[0].id)
        XCTAssertEqual(item.text, file.items[0].text)
        XCTAssertEqual(item.importance, file.items[0].importance)
        XCTAssertEqual(item.deadline, file.items[0].deadline)
        XCTAssertEqual(item.isDone, file.items[0].isDone)
        XCTAssertEqual(item.createdAt, file.items[0].createdAt)
    }
    
    func testFileCacheRemoveItem() {
        let item = ToDoItem(id: "1", text: "adlet", importance: .important, deadline: .now, isDone: true, createdAt: .now, modifiedAt: .now)
        let file = FileCache()
        
        file.addItem(item)
        file.deleteItem(item.id)
        
        XCTAssertEqual(file.items.count, 0)
    }
    
    func testFileCacheSaveLoad() {
        
        let file = FileCache()
        let item = ToDoItem(text: "adlet", importance: .usual, createdAt: .now)
        file.addItem(item)
        
        do {
            try file.saveToCSV(to: "items.txt")
            try file.loadCSV(from: "items.txt")
        } catch {
            XCTFail("Saving or loading file threw an error: \(error)")
        }
        
        XCTAssertTrue(file.items.contains { $0.id == item.id })
    }

}
