//
//  FileCache.swift
//  ToDoListApp
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import Foundation

final class FileCache {
    
    private(set) var items = [ToDoItem]()
    
    //MARK: - Add
    
    func addItem(_ item: ToDoItem) {
        if items.contains(where: { $0.id == item.id }) {
            items.removeAll { $0.id == item.id }
        }
        items.append(item)
    }
    
    //MARK: - Delete
    
    func deleteItem(_ id: String) {
        items.removeAll(where: { $0.id == id })
    }
    
    //MARK: - SaveToCSV
    
    func saveToCSV(to fileName: String) throws {
        
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDir.appendingPathComponent("\(fileName).csv")
        
        var csvData = ""
        
        for item in items {
            var str = ""
            
            var components: [String] = [item.id, item.text, String(item.isDone), String(item.createdAt.timeIntervalSince1970)]
          
            if item.importance != .usual {
                components.append(item.importance.rawValue)
            } else {
                components.append(" ")
            }
            
            if let deadline = item.deadline {
                components.append(String(deadline.timeIntervalSince1970))
            } else {
                components.append(" ")
            }
            
            if let modifiedAt = item.modifiedAt {
                components.append(String(modifiedAt.timeIntervalSince1970))
            } else {
                components.append(" ")
            }
            
            str = components.joined(separator: ",") + "\n"
            print(str)
            csvData += str
            
        }
        
        try csvData.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    //MARK: - parseCSV
    
    func loadCSV(from fileName: String) throws {
        
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDir.appendingPathComponent("\(fileName).csv")
        
        let csvString = try String(contentsOf: fileURL)
        
        let string = csvString.split(separator: "\n")
        
        for str in string {
            let arr = str.split(separator: ",")
            print(arr)
            let id = String(arr[0])
            let text = String(arr[1])
            let isDone = Bool(String(arr[2]))
            let createdAt = Date(timeIntervalSince1970: Double(arr[3]) ?? 0)
            
            var importance = ToDoItem.Importance.usual
            if arr.count > 4 && String(arr[4]) != "обычная" {
                importance = ToDoItem.Importance(rawValue: String(arr[4])) ?? .usual
            }

            var deadlineDate: Date?
            if arr.count > 5 {
                deadlineDate = Date(timeIntervalSince1970: Double(arr[5]) ?? 0)
            }
            
            var modifiedDate: Date?
            if arr.count > 6 {
                modifiedDate = Date(timeIntervalSince1970: Double(arr[6]) ?? 0)
            }
            
            let item = ToDoItem(id: id,
                                text: text,
                                importance: importance,
                                deadline: deadlineDate,
                                isDone: isDone ?? false,
                                createdAt: createdAt,
                                modifiedAt: modifiedDate)
            print(item)
            self.items.append(item)
        }
    }
    
    //MARK: - SaveToJSON
    
    func saveJSON(to fileName: String) throws {
        
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDir.appendingPathComponent("\(fileName).json")
        print(fileURL)
        let toDoItemsJsons = items.map {
            $0.json
        }
        guard JSONSerialization.isValidJSONObject(toDoItemsJsons),
              let jsonData = try? JSONSerialization.data(withJSONObject: toDoItemsJsons, options: .prettyPrinted) else {
            throw FileCacheError.jsonConversion
        }
        
        try jsonData.write(to: fileURL)
    }
    
    //MARK: - LoadJSON
    
    func loadJSON(from fileName: String) throws {
        
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDir.appendingPathComponent("\(fileName).json")
        
        let jsonData = try Data(contentsOf: fileURL)
        let decodedObject = try JSONSerialization.jsonObject(with: jsonData)
        
        guard let dictionaries = decodedObject as? [[String: Any]] else {
            throw FileCacheError.jsonDecode
        }
        
        for dictionary in dictionaries {
            if let item = ToDoItem.parse(json: dictionary) {
                if items.contains(where: { $0.id == item.id }) {
                    items.removeAll { $0.id == item.id }
                }
                self.items.append(item)
            }
        }
    }
    
    //MARK: - Helpers
    
    enum FileCacheError: String, Error {
        case jsonConversion = "can't serialize to json"
        case jsonDecode = "can't decode json"
    }
}
