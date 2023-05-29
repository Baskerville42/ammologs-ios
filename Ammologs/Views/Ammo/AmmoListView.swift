//
//  AmmoListView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct AmmoListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ammo.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Ammo>
    
    @State private var isAddingAmmo = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        AmmoDetailView(ammo: item)
                    } label: {
                        Text(item.name!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle(NSLocalizedString("Ammos", comment: ""))
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                ToolbarItem {
                    Button(action: {
                            isAddingAmmo = true
                    }) {
                        Label(NSLocalizedString("New ammo", comment: ""), systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingAmmo) {
            AmmoAddView(isPresented: $isAddingAmmo)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
