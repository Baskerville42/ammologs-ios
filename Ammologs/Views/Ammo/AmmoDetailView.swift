//
//  AmmoDetailView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI
import CoreData

struct AmmoDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var ammo: Ammo
    
    var body: some View {
        VStack {
            Section {
                if let url = URL(string: ammo.photo ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "tennisball")
                                .foregroundColor(.white)
                            Text("Name")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(ammo.name ?? "No Ammo")")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(5)
                .background(Color.purple)
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
                            Image(systemName: "tennis.racket")
                                .foregroundColor(.white)
                            Text("Weapons")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        ForEach(Array(ammo.weapons as? Set<Weapon> ?? []), id: \.self) { weapon in
                            Text(weapon.name ?? "No Weapon")
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
                
                HStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Link(destination: URL(string: ammo.linkToStore!)!) {
                                HStack {
                                    Text("Open in browser")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                    Image(systemName: "link")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    AmmoSettingsView(ammo: ammo)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle(ammo.name ?? "")
    }
    
    private func calculateTotalShots() -> Int {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ammo == %@", ammo)

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
