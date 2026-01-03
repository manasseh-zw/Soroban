//
//  SorobanApp.swift
//  Soroban
//
//  Created by Manasseh on 02/01/2026.
//

import SwiftUI

@main
struct SorobanApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear {
                    #if os(macOS)
                    NSApp.appearance = NSAppearance(named: .darkAqua)
                    #endif
                }
        }
        .defaultSize(width: 700, height: 500)
        .windowResizability(.contentSize)
    }
}
