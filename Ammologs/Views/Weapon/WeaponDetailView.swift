//
//  WeaponDetailView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI
import CoreData

struct WeaponDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var weapon: Weapon
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "tennis.racket")
                                .foregroundColor(.white)
                            Text("Name")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(weapon.name ?? "No Weapon name")")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(5)
                .background(Color.green)
                .cornerRadius(10)
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "42.square")
                                .foregroundColor(.white)
                            Text("Total shots")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(calculateTotalShots())")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(5)
                .background(Color.red)
                .cornerRadius(10)
            }
            
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "tennisball")
                                .foregroundColor(.white)
                            Text("Ammos")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        ForEach(Array(weapon.ammos as? Set<Ammo> ?? []), id: \.self) { ammo in
                            Text(ammo.name ?? "No Ammo")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(5)
                .background(Color.purple)
                .cornerRadius(10)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    WeaponSettingsView(weapon: weapon)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle(weapon.name ?? "")
    }
    
    private func calculateTotalShots() -> Int {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weapon == %@", weapon)

        do {
            let sessions = try viewContext.fetch(fetchRequest)
            let totalShots = sessions.reduce(0) { $0 + Int($1.count) }
            return totalShots
        } catch {
            return 0
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
