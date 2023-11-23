//
//  Item.swift
//  HeartRate
//
//  Created by Fabio Falco on 15/11/23.
//
import Foundation
import SwiftData

@Model
final class Entry:ObservableObject{
    var title: String
    var content: String
    var date: Date
    
    init(title: String, content: String, date: Date) {
        self.title = title
        self.content = content
        self.date = date
    }
}

