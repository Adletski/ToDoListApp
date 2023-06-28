//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by Adlet Zhantassov on 28.06.2023.
//

import Foundation

struct ToDoItem {
    
    enum Importance: String, CaseIterable {
        case notImportant = "неважная"
        case usual = "обычная"
        case important = "важная"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let modifiedAt: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date,
        modifiedAt: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
}

extension ToDoItem {
    
    private enum Constants {
        static let id = "id"
        static let text = "text"
        static let importance = "importance"
        static let deadline = "deadline"
        static let isDone = "done"
        static let createdAt = "createdAt"
        static let modifiedAt = "modifiedAt"
    }
    
    //MARK: - Make JSON
    
    var json: Any {
        
        var dictionary: [String: Any] = [
            Constants.id: id,
            Constants.text: text,
            Constants.isDone: isDone,
            Constants.createdAt: createdAt.timeIntervalSince1970
        ]
        
        if importance != .usual {
            dictionary[Constants.importance] = importance.rawValue
        }
        
        if let deadline = deadline {
            dictionary[Constants.deadline] = deadline.timeIntervalSince1970
        }
        
        if let modifiedAt = modifiedAt {
            dictionary[Constants.modifiedAt] = modifiedAt.timeIntervalSince1970
        }
        
        return dictionary
    }
    
    //MARK: - Parse JSON
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dictionary = json as? [String: Any],
              let id = dictionary[Constants.id] as? String,
              let text = dictionary[Constants.text] as? String,
              let isDone = dictionary[Constants.isDone] as? Bool,
              let createdAt = dictionary[Constants.createdAt] as? Double else { return nil }
        
        let createDate = Date(timeIntervalSince1970: createdAt)
        
        var importance = Importance.usual
        if let importanceUnwrapped = dictionary[Constants.importance] as? String {
            importance = ToDoItem.Importance(rawValue: importanceUnwrapped) ?? .usual
        }
        
        var deadlineDate: Date?
        if let deadlineUnwrapped = dictionary[Constants.deadline] as? Double {
            deadlineDate = Date(timeIntervalSince1970: deadlineUnwrapped)
        }
        
        var modifiedDate: Date?
        if let modifiedUnwrapped = dictionary[Constants.modifiedAt] as? Double {
            modifiedDate = Date(timeIntervalSince1970: modifiedUnwrapped)
        }
        
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadlineDate,
                        isDone: isDone,
                        createdAt: createDate,
                        modifiedAt: modifiedDate)
    }
    
    //MARK: - Save to CSV
    
    var csv: String {
        var components: [String] = [id, text, String(isDone), String(createdAt.timeIntervalSince1970)]
        
        if importance != .usual {
            components.append(importance.rawValue)
        } else {
            components.append(" ")
        }

        if let deadline = deadline {
            components.append(String(deadline.timeIntervalSince1970))
        } else {
            components.append(" ")
        }
        
        if let modifiedAt = modifiedAt {
            components.append(String(modifiedAt.timeIntervalSince1970))
        } else {
            components.append(" ")
        }
        
        return components.joined(separator: ",")
    }
    
    //MARK: - Parse from CSV
    
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ",")
        
        let id = components[0]
        let text = components[1]
        let isDone = Bool(components[2]) ?? false
        let createdAt = Date(timeIntervalSince1970: Double(components[3]) ?? 0)
        let importance = Importance(rawValue: components[4]) ?? .usual
        
        var deadline: Date?
        if let deadlineTimestamp = Double(components[5]) {
            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
        }
        
        var modifiedDate: Date?
        if let modifiedUnwrapped = Double(components[6]) {
            modifiedDate = Date(timeIntervalSince1970: modifiedUnwrapped)
        }
        
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        createdAt: createdAt,
                        modifiedAt: modifiedDate)
    }
    
}
