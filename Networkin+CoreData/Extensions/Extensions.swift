//
//  Extensions.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/13.
//

import Foundation
import CoreData
import SwiftUI

extension NoteDTO {
    func toNote(context: NSManagedObjectContext){
        let note = Note(context: context)
        note.id = self.id
        note.title = self.title
        note.content = self.content
        note.date = self.date
        note.color = self.color
    }
}

extension Note {
    func toDto() -> NoteDTO {
        return NoteDTO(
            title: self.title ?? "Unknown title",
            content: self.content ?? "Unknown content",
            date: self.date,
            color: self.color ?? "",
            id: self.id ?? UUID().uuidString
        )
    }
}
extension UINote {
    func toDto() -> NoteDTO {
        return NoteDTO(
            title: self.title == "" ? nil : self.title,
            content: self.content  == "" ? nil : self.content,
            date: self.date,
            color: self.color,
            id: self.id
        )
    }
}
extension Color {
    static subscript(name: String) -> Color {
        switch name {
        case "green":
            return Color.green
        case "teal":
            return Color.teal
        case "accent":
            return Color.accentColor
        case "pink":
            return Color.pink
        case "mint":
            return Color.mint
        case "purple":
            return Color.purple
        case "orange":
            return Color.orange
        case "brown":
            return Color.brown
        case "indigo":
            return Color.indigo
        case "cyan":
            return Color.cyan
        default:
            return Color.accentColor
        }
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var customFormat: String {
        let calendar = Calendar.current
        var formattedValue = ""
        if calendar.isDateInToday(self) {
            formattedValue += "Today"
        }else if calendar.isDateInTomorrow(self) {
            formattedValue += "Tomorrow"
        } else if calendar.isDateInYesterday(self) {
            formattedValue += "Yesterday"
        }else if calendar.isDateInWeekend(self) {
            formattedValue += self.formatted(.dateTime.weekday())
        }
        if formattedValue.isEmpty {
            formattedValue = self.formatted(.dateTime.day())
            formattedValue += " \(self.formatted(.dateTime.month().year(.twoDigits).hour().minute()))"
        }else {
            formattedValue += ", \(self.formatted(.dateTime.hour().minute()))"
        }
        return formattedValue
    }
}
