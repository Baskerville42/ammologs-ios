//
//  SessionListView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct SessionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var quickActionSettings: QuickActionSettings

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Weapon.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Session>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        SessionDetailView(session: item)
                    } label: {
                        Text(item.desc ?? "")
                    }
                }.onDelete(perform: deleteItems)
            }
            
            .navigationBarTitle(NSLocalizedString("Sessions", comment: ""))
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                ToolbarItem {
                    Button(action: {
                        quickActionSettings.isAddingSession = true
                    }) {
                        Label(NSLocalizedString("Add Item", comment: ""), systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $quickActionSettings.isAddingSession) {
            SessionAddView(isPresented: $quickActionSettings.isAddingSession)
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

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
