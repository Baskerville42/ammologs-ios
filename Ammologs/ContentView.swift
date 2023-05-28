//
//  ContentView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 27.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SessionListView()
                .tabItem{
                    Label("Sessions", systemImage: "figure.hunting")
                }
            WeaponListView()
                .tabItem{
                    Label("Weapons", systemImage: "tennis.racket")
                }
            AmmoListView()
                .tabItem{
                    Label("Ammos", systemImage: "tennisball")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
