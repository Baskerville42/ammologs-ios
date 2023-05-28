//
//  AmmoAddView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct AmmoAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var photo = "https://ibis.net.ua/static/products_pictures/f/3/8/patron-zala-arms-ipsc-kal-1270-drob-6-275-mm-naveska-32-g.jpg"
    @State private var linkToStore = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Photo", text: $photo)
                TextField("Link to store", text: $linkToStore)
            }
            
            .navigationTitle("Add Ammo")
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
            let newItem = Ammo(context: viewContext)
            newItem.id = UUID()
            newItem.timestamp = Date()
            newItem.name = name
            newItem.photo = photo
            newItem.linkToStore = linkToStore

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
