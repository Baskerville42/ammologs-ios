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
    @State private var shootingDate = Date()
    
    var body: some View {
        Form {
            Section {
                List {
                    TextField(NSLocalizedString("Description", comment: ""), text: $desc)
                    TextField(NSLocalizedString("Count", comment: ""), value: $count, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
            }
            
            Section(header: Text(NSLocalizedString("Select weapon", comment: ""))) {
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
            
            if let weaponAmmos = session.weapon?.ammos as? Set<Ammo> {
                let sortedAmmos = weaponAmmos.sorted {
                    $0.name! < $1.name!
                }
                Section(header: Text(NSLocalizedString("Select ammo", comment: ""))) {
                    List {
                        ForEach(sortedAmmos) { item in
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
        }
        
        .onAppear {
            loadSessionDetails()
        }
        .toolbar {
            ToolbarItem {
                Button(action: saveSession) {
                    Text(NSLocalizedString("Save", comment: ""))
                }
            }
        }
        .navigationTitle(NSLocalizedString("Properties", comment: ""))
    }
    
    private func loadSessionDetails() {
        desc = session.desc ?? ""
        count = Int(session.count)
        shootingDate = session.timestamp ?? Date()
    }
    
    private func saveSession() {
        session.desc = desc
        session.count = Int16(count)
        session.timestamp = shootingDate

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
        session.ammo = nil
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

