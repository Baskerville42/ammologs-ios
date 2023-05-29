//
//  SessionAddView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 28.05.2023.
//

import SwiftUI

struct SessionAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var desc = ""
    @State private var count: Int = 25
    
    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Description", comment: ""), text: $desc)
                TextField(NSLocalizedString("Count", comment: ""), value: $count, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            .navigationTitle(NSLocalizedString("New session", comment: ""))
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Text(NSLocalizedString("Save", comment: ""))
                    }
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Session(context: viewContext)
            newItem.timestamp = Date()
            newItem.desc = desc
            newItem.count = Int16(count)
            newItem.id = UUID()

            do {
                try viewContext.save()
                isPresented = false
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
