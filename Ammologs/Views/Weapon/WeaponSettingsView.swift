//
//  WeaponSettingsView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct WeaponSettingsView: View {
    let weapon: Weapon
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ammo.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Ammo>
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    
    var body: some View {
        Form {
            Section {
                List {
                    TextField(NSLocalizedString("Name", comment: ""), text: $name)
                }
            }
            
            Section(header: Text(NSLocalizedString("Select ammo", comment: ""))) {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            if weapon.ammos?.contains(where: { ($0 as? Ammo)?.id == item.id }) == true {
                                deleteAmmo(from: weapon, ammoID: item.id!)
                            } else {
                                addAmmo(to: weapon, ammoID: item.id!)
                            }
                        }, label: {
                            HStack {
                                if weapon.ammos?.contains(where: { ($0 as? Ammo)?.id == item.id }) == true {
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
                    Text(NSLocalizedString("Save", comment: ""))
                }
            }
        }
        .navigationTitle(NSLocalizedString("Properties", comment: ""))
    }
    
    private func loadWeaponDetails() {
        name = weapon.name ?? ""
    }
    
    private func saveWeapon() {
        weapon.name = name

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addAmmo(to weapon: Weapon, ammoID: UUID) {
        guard let ammo = viewContext.registeredObjects.first(where: { ($0 as? Ammo)?.id == ammoID }) as? Ammo else { return }
        weapon.addToAmmos(ammo)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteAmmo(from weapon: Weapon, ammoID: UUID) {
        guard let ammo = viewContext.registeredObjects.first(where: { ($0 as? Ammo)?.id == ammoID }) as? Ammo else { return }
        weapon.removeFromAmmos(ammo)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
