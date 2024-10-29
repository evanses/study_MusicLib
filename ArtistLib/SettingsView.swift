//
//  SettingsView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                Toggle(isOn: .constant(true)) {
                    Text("Enable notifications")
                }
            }
            Section {
                // slider to change angle of the color gradient view bellow
                ColorGradientView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
