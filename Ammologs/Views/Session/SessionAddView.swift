//
//  SessionAddView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 28.05.2023.
//

import SwiftUI

struct SessionAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ammo.name, ascending: true)],
        animation: .default) private var ammos: FetchedResults<Ammo>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Weapon.name, ascending: true)],
        animation: .default) private var weapons: FetchedResults<Weapon>
    
    @Binding var isPresented: Bool
    
    @State private var selectedWeapon: Weapon? = nil
    @State private var selectedAmmo: UUID? = nil
    @State private var desc = ""
    @State private var count: Int = 25
    @State private var shootingDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Description", comment: ""), text: $desc)
                TextField(NSLocalizedString("Count", comment: ""), value: $count, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                DatePicker(NSLocalizedString("Date", comment: ""), selection: $shootingDate, in: ...Date(), displayedComponents: [.date])
                
                Section(header: Text(NSLocalizedString("Select weapon", comment: ""))) {
                    List {
                        ForEach(weapons) { item in
                            Button(action: {
                                if selectedWeapon?.id == item.id {
                                    selectedWeapon = nil
                                } else {
                                    selectedWeapon = item
                                }
                            }, label: {
                                HStack {
                                    if selectedWeapon?.id == item.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else {
                                        Image(systemName: "checkmark.circle")
                                    }

                                    Text(item.name!)
                                }
                            })
                        }
                    }
                }
                
                if let weaponAmmos = selectedWeapon?.ammos as? Set<Ammo> {
                    let sortedAmmos = weaponAmmos.sorted {
                        $0.name! < $1.name!
                    }
                    Section(header: Text(NSLocalizedString("Select ammo", comment: ""))) {
                        List {
                            ForEach(sortedAmmos) { item in
                                Button(action: {
                                    if selectedAmmo == item.id {
                                        selectedAmmo = nil
                                    } else {
                                        selectedAmmo = item.id
                                    }
                                }, label: {
                                    HStack {
                                        if selectedAmmo == item.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "checkmark.circle")
                                        }

                                        Text(item.name!)
                                    }
                                })
                            }
                        }
                    }
                }
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
            newItem.timestamp = shootingDate
            newItem.desc = desc
            newItem.count = Int16(count)
            newItem.id = UUID()
            
            newItem.weapon = selectedWeapon

            if let ammoID = selectedAmmo {
                let ammo = ammos.first { $0.id == ammoID }
                newItem.ammo = ammo
            }

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
