//
//  NoteItemView.swift
//  Networkin+CoreData
//
//  Created by dremobaba on 2023/1/12.
//

import SwiftUI
import CoreData


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

struct NoteItemView: View {
    let note: Note
    let onPress:()->Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(note.title ?? "unknown")
                .fontWeight(.bold)
                .font(.title3)
                .lineLimit(2)
            if note.content != nil {
                Text(note.content!)
                    .lineLimit(3)
            }
               
            Text(Date(milliseconds: note.date).customFormat)
                .padding(5)
                .font(.caption)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black)
                }
                .padding(.bottom, 10)
        }
       .frame(maxWidth: .infinity)
        .padding(15)
        .multilineTextAlignment(.leading)
        .background(Color[note.color ?? "accent"].opacity(0.7))
        .cornerRadius(12)
        .padding()
        .onTapGesture {
            onPress()
        }
    }
}

struct NoteItemView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var previews: some View {
        let note = Note(context: context)
        note.id = UUID().uuidString
        note.title = "Team Meeting"
        note.content = ""
        note.color = "green"
        note.date = Date().millisecondsSince1970
        return NoteItemView(note: note, onPress: {})
    }
}
