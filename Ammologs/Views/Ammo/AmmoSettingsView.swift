//
//  AmmoSettingsView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct AmmoSettingsView: View {
    let ammo: Ammo
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Weapon.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Weapon>
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var photo = ""
    @State private var linkToStore = ""
    
    var body: some View {
        Form {
            Section {
                List {
                    TextField("Name", text: $name)
                    TextField("Photo", text: $photo)
                    TextField("Link to store", text: $linkToStore)
                }
            }
            
            Section(header: Text("Select a weapon for this ammo")) {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            if ammo.weapons?.contains(where: { ($0 as? Weapon)?.id == item.id }) == true {
                                deleteWeapon(from: ammo, weaponID: item.id!)
                            } else {
                                addWeapon(to: ammo, weaponID: item.id!)
                            }
                        }, label: {
                            HStack {
                                if ammo.weapons?.contains(where: { ($0 as? Weapon)?.id == item.id }) == true {
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
            loadAmmoDetails()
        }
        .toolbar {
            ToolbarItem {
                Button(action: saveAmmo) {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Preferences")
    }
    
    private func loadAmmoDetails() {
        name = ammo.name ?? ""
        photo = ammo.photo ?? ""
        linkToStore = ammo.linkToStore ?? ""
    }
    
    private func saveAmmo() {
        ammo.name = name
        ammo.photo = photo
        ammo.linkToStore = linkToStore

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addWeapon(to ammo: Ammo, weaponID: UUID) {
        guard let weapon = viewContext.registeredObjects.first(where: { ($0 as? Weapon)?.id == weaponID }) as? Weapon else { return }
        ammo.addToWeapons(weapon)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteWeapon(from ammo: Ammo, weaponID: UUID) {
        guard let weapon = viewContext.registeredObjects.first(where: { ($0 as? Weapon)?.id == weaponID }) as? Weapon else { return }
        ammo.removeFromWeapons(weapon)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
