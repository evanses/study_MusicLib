//
//  SettingsView.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

import SwiftUI

@Observable class ColorTheme {
    
    enum Theme: String, CaseIterable {
        case `default`, light, dark
    }
    
    var current = Theme.default
    
    var theme: ColorScheme? {
        switch current {
        case .default: .none
        case .light: .light
        case .dark: .dark
        }
    }
}

struct SettingsView: View {
    @Binding var titleOn: Bool {
        didSet {
            print("changed")
        }
    }
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            Section {
                Text("\(colorScheme == .dark ? "Dark Theme enabled" : "Light Theme enabled")").bold()
            }
            Section {
                Toggle(isOn: $titleOn) {
                    Text("Включить отображение заголовка списка")
                }
                if titleOn {
                    Text("Navigation title enabled")
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
    SettingsView(titleOn: .constant(true))
        .environment(ColorTheme())
}
