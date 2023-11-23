//
//  ListItemField.swift
//  HeartRate
//
//  Created by Fabio Falco on 17/11/23.
//

import SwiftUI

//Funzione per aggiungere un feedback di vibrazione
func impactFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
      generator.prepare()
      generator.impactOccurred()
}
//Extend in order to compare Date
extension Date {
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
}

//Used to display items of the list
struct DisplayItemList:View {
    @State var entry:Entry
    var body: some View {
        Text(dateFormatter.string(from: entry.date))
            .font(.subheadline)
            .foregroundColor(.gray)
            .accessibilityHidden(true)
        HStack{
            VStack{
                Text("Upper pressure").font(.headline)
                Text(entry.title)
            }
            Spacer()
            VStack{
                Text("Lower pressure").font(.headline)
                Text(entry.content)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to edit the values")
    }
    //in order to format the date
    var dateFormatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
//Display the fields in the modal view
struct ListItemField:View {
    @Binding var title:String
    @Binding var content:String
    var body: some View {
        TextField("Upper pressure", text: $title)
            .keyboardType(.numberPad)
        TextField("Lower pressure", text: $content)
            .keyboardType(.numberPad)
    }
}

//Basic body of the modal
struct SheetBody:View {
    @Binding var title:String
    @Binding var content:String
    @Binding var showSheet:Bool
    var addEntry: (String,String) -> Void
    
    
    var body: some View {
        NavigationStack{
            Form{
                ListItemField(title: $title, content: $content)
            }
            .navigationTitle("Add Measurement")
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    .accessibilityHint("Double tap to exit the view")
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        if(!title.isEmpty && !content.isEmpty){
                            addEntry(title,content)
                            title = ""
                            content = ""
                            showSheet.toggle()
                            impactFeedback()
                        }
                    } label: {
                        Text("Save")
                    }
                    .accessibilityHint("Double tap to save your values into the journal")
                }
            }
        }
    }
}
//modifyed modal in order to update existing item in list

struct EditSheetBody:View {
    @Binding var showSheet:Bool
    var addEntry: (String,String) -> Void
    @ObservedObject var item: Entry
    @Binding var isPresented: Entry?
    
    
    var body: some View {
        NavigationStack{
            Form{
                ListItemField(title: $item.title, content: $item.content)
            }
            .navigationTitle("Add Measurement")
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        isPresented = nil
                    }, label: {
                        Image(systemName: "chevron.down")
                    }).accessibilityHint("Double tap to exit the view")
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        isPresented = nil
                        impactFeedback()
                    } label: {
                        Text("Save")
                    }
                    .accessibilityHint("Double tap to save your values into the journal")
                }
            }
        }
    }
}
