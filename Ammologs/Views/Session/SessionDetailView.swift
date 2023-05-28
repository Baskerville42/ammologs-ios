//
//  SessionDetailView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 28.05.2023.
//

import SwiftUI

struct SessionDetailView: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            Text("Date")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(session.timestamp ?? Date(), formatter: itemFormatter)")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(5)
                .background(Color.orange)
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
                        Text("\(session.count)")
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
                            Text("Weapon")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(session.weapon?.name ?? "No Weapon")")
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
                            Image(systemName: "tennisball")
                                .foregroundColor(.white)
                            Text("Ammo")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Text("\(session.ammo?.name ?? "No Ammo")")
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
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    SessionSettingsView(session: session)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle(session.desc ?? "")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
    return formatter
}()
