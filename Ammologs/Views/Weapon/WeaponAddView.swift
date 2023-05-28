//
//  WeaponAddView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct WeaponAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
            }
            
            .navigationTitle("Add Weapon")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Text("Save")
                    }
                }
            }
        }
        
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Weapon(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = name
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
