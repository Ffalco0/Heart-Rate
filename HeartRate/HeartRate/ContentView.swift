//
//  ContentView.swift
//  HeartRate
//
//  Created by Fabio Falco on 15/11/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    //This two istances are used for SwiftData,
    //the first one is used to create the variable that hold the context
    //the second instead is used to retrive the class from the model
    @Environment(\.modelContext) private var context
    @Query private var entries: [Entry]
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedItem: Entry?
    
    
    //This one is used to manipulate the modal
    @State  private var showSheet = false
    
    //used to select date for filter
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                if(filteredItems.isEmpty){
                    Text("Add new measurement by tapping on the + button")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("Add new measurement by tapping on the new measurement button")
                }else{
                    List{
                        ForEach(filteredItems.sorted(by: { $0.date > $1.date }), id: \.self){ entry in
                            Section{
                                VStack(alignment: .trailing){
                                    DisplayItemList(entry: entry)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedItem = entry
                                }
                                .accessibilityAction {
                                    selectedItem = entry
                                }
                            }
                        }
                        .onDelete(perform: { indexes in
                            for index in indexes{
                                deleteEntry(filteredItems.sorted(by: { $0.date > $1.date })[index])
                            }
                        })
                    }//List
                }
            }
            .navigationTitle(
                Text("Journal")
                    .accessibilityLabel("Your pressur value")
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    DatePicker(String(), selection: $selectedDate, displayedComponents: [.date])
                        .accessibilityLabel("Select the date of your measurement")
                        .accessibilityHint("Double tap to select a date")
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        showSheet.toggle()
                        impactFeedback()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityHint("Double tap to insert new values")
                    .accessibilityLabel("Insert new measure")
                    .accessibilityAddTraits(.isButton)
                }
            }
            
            //Sheet used for create a new element
            .sheet(isPresented: $showSheet) {
                SheetBody(title: $title, content: $content, showSheet: $showSheet, addEntry: addEntry)
            }//Sheet
            //Sheet used to modify an existing element
            .sheet(item: $selectedItem ) { selectedItem in
                EditSheetBody(showSheet: $showSheet, addEntry: addEntry, item: selectedItem,isPresented: $selectedItem)
            }
            //Sheet for mod
            
        }//NavigationStack
    }//Body
    
    //Function that add an entry to the list
    func addEntry(title:String,content:String){
        //Create an item
        let entry = Entry(title: title, content: content, date: Date())
        //Add the item to the context
        context.insert(entry)
    }
    //Funtion that delete an entry from the list
    func deleteEntry(_ entry:Entry){
        context.delete(entry)
    }
    //Create filtered list
    var filteredItems: [Entry] {
        return entries.filter { $0.date.isSameDay(as: selectedDate) }
    }
  
    
}//View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       // ContentView()
        MainActor.assumeIsolated {
               ContentView()
                .modelContainer(for:Entry.self)
           }
    }
}
