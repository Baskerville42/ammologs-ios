//
//  AboutAppView.swift
//  Ammologs
//
//  Created by Alexander Tartmin on 31.05.2023.
//  Copyright © 2023 Alexander Tartmin. All rights reserved.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }) {
                        Text(NSLocalizedString("AppSettings", comment: ""))
                    }
                }
                .navigationBarTitle(NSLocalizedString("Settings", comment: ""))

                Spacer()

                VStack {
                    Text("\(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Не знайдено")")
                        .font(.title2)
                    HStack {
                        Text("v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Не знайдено") (\(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Не знайдено"))")
                            .font(.caption2)
                    }
                }
                .padding()

                Spacer()

                VStack {
                    Text("Alexander Tartmin")
                        .font(.caption)
                    Text(NSLocalizedString("Copyright", comment: ""))
                        .font(.caption)
                }
                .padding(.bottom)
            }
        }
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
