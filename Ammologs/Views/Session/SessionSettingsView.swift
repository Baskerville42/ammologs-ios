//
//  SessionSettingsView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 28.05.2023.
//

import SwiftUI

struct SessionSettingsView: View {
    let session: Session
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ammo.name, ascending: true)],
        animation: .default) private var ammos: FetchedResults<Ammo>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Weapon.name, ascending: true)],
        animation: .default) private var weapons: FetchedResults<Weapon>
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var desc = ""
    @State private var count: Int = 0
    
    var body: some View {
        Form {
            Section {
                List {
                    TextField("Description", text: $desc)
                    TextField("Count", value: $count, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
            }
            
            Section(header: Text("Select an weapon for this session")) {
                List {
                    ForEach(weapons) { item in
                        Button(action: {
                            if session.weapon?.id == item.id {
                                deleteWeapon(from: session)
                            } else {
                                addWeapon(to: session, weaponID: item.id!)
                            }
                        }, label: {
                            HStack {
                                if session.weapon?.id == item.id {
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
            
            Section(header: Text("Select an ammo for this session")) {
                List {
                    ForEach(ammos) { item in
                        Button(action: {
                            if session.ammo?.id == item.id {
                                deleteAmmo(from: session)
                            } else {
                                addAmmo(to: session, ammoID: item.id!)
                            }
                        }, label: {
                            HStack {
                                if session.ammo?.id == item.id {
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
        
        .onAppear {
            loadWeaponDetails()
        }
        .toolbar {
            ToolbarItem {
                Button(action: saveWeapon) {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Preferences")
    }
    
    private func loadWeaponDetails() {
        desc = session.desc ?? ""
        count = Int(session.count)
    }
    
    private func saveWeapon() {
        session.desc = desc
        session.count = Int16(count)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addAmmo(to session: Session, ammoID: UUID) {
        guard let ammo = viewContext.registeredObjects.first(where: { ($0 as? Ammo)?.id == ammoID }) as? Ammo else { return }

        session.ammo = ammo

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteAmmo(from session: Session) {
        session.ammo = nil

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addWeapon(to session: Session, weaponID: UUID) {
        guard let weapon = viewContext.registeredObjects.first(where: { ($0 as? Weapon)?.id == weaponID }) as? Weapon else { return }
        
        session.weapon = weapon
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteWeapon(from session: Session) {
        session.weapon = nil
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

