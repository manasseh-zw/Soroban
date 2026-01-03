//
//  ContentView.swift
//  Soroban
//
//  Created by Manasseh on 02/01/2026.
//

import SwiftUI

struct ContentView: View {
    enum PlaceValueMode: String {
        case rightmostUnits
        case centerUnits
    }
    
    @State private var heavenBeads: [Bool] = Array(repeating: false, count: 13)
    @State private var earthBeads: [[Bool]] = Array(repeating: Array(repeating: false, count: 4), count: 13)
    @State private var placeValueMode: PlaceValueMode = .centerUnits
    
    private var unitRodIndex: Int {
        switch placeValueMode {
        case .rightmostUnits:
            return heavenBeads.count - 1
        case .centerUnits:
            return heavenBeads.count / 2
        }
    }
    
    private var totalValue: Double {
        var total = 0.0
        for i in 0..<13 {
            let exponent = unitRodIndex - i
            let placeValue = pow(10.0, Double(exponent))
            if heavenBeads[i] {
                total += 5 * placeValue
            }
            for j in 0..<4 {
                if earthBeads[i][j] {
                    total += placeValue
                }
            }
        }
        return total
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(formatNumber(totalValue))
                .font(.system(size: 32, weight: .light, design: .monospaced))
                .foregroundColor(.white)
                .padding(.bottom, 28)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(nsColor: .windowBackgroundColor))
                
                HStack(spacing: 0) {
                    ForEach(0..<13, id: \.self) { rodIndex in
                        RodView(
                            heavenActive: $heavenBeads[rodIndex],
                            earthActive: $earthBeads[rodIndex]
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            HStack {
                Button("Clear") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        heavenBeads = Array(repeating: false, count: 13)
                        earthBeads = Array(repeating: Array(repeating: false, count: 4), count: 13)
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)
                
                Spacer()
                
                Toggle(isOn: Binding(
                    get: { placeValueMode == .centerUnits },
                    set: { placeValueMode = $0 ? .centerUnits : .rightmostUnits }
                )) {
                    Text("Use decimals")
                }
                .toggleStyle(.switch)
            }
            .padding(.top, 28)
        }
        .padding(24)
        .frame(width: 700, height: 500)
    }
    
    private func formatNumber(_ number: Double) -> String {
        let rounded = (number * 1_000_000).rounded() / 1_000_000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = placeValueMode == .centerUnits ? 6 : 0
        return formatter.string(from: NSNumber(value: rounded)) ?? "0"
    }
}

struct RodView: View {
    @Binding var heavenActive: Bool
    @Binding var earthActive: [Bool]
    
    private let beadHeight: CGFloat = 26
    private let beadSpacing: CGFloat = 4  // Increased spacing by 2 pixels
    private let barHeight: CGFloat = 8
    private let barPosition: CGFloat = 0.28 // Bar at 28% from top (heaven section is smaller)
    
    // Retro Mac sky blue for heaven bead
    private let heavenColor = Color(red: 0.345, green: 0.675, blue: 0.910) // #58ACE8
    // Whiter metallic for earth beads
    private let earthColor = Color(red: 0.7, green: 0.7, blue: 0.75)
    
    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let barY = totalHeight * barPosition
            
            ZStack(alignment: .top) {
                // Rod (vertical bar)
                let rodBottomY = totalHeight - 14
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.8, green: 0.8, blue: 0.85)) // White metallic rod
                    .frame(width: 4, height: rodBottomY)
                
                // Dividing bar
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(red: 0.6, green: 0.6, blue: 0.65).opacity(0.3)) // See-through silver bar
                    .frame(height: barHeight)
                    .offset(y: barY - barHeight / 2)
                
                // Heaven bead
                let heavenInactiveY: CGFloat = 8
                let heavenActiveY: CGFloat = barY - barHeight / 2 - beadHeight - 4
                
                BeadView(color: heavenColor)
                    .frame(height: beadHeight)
                    .shadow(color: .black.opacity(heavenActive ? 0.4 : 0.2), radius: heavenActive ? 4 : 2, x: 0, y: heavenActive ? 2 : 1)
                    .offset(y: heavenActive ? heavenActiveY : heavenInactiveY)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            heavenActive.toggle()
                        }
                    }
                
                // Earth beads
                let earthTopY = barY + barHeight / 2 + 4
                let earthBottomY = totalHeight - 18 - (CGFloat(4) * (beadHeight + beadSpacing))
                
                ForEach(0..<4, id: \.self) { beadIndex in
                    let activeY = earthTopY + CGFloat(beadIndex) * (beadHeight + beadSpacing)
                    let inactiveY = earthBottomY + CGFloat(beadIndex) * (beadHeight + beadSpacing)
                    
                    BeadView(color: earthColor)
                        .frame(height: beadHeight)
                        .shadow(color: .black.opacity(earthActive[beadIndex] ? 0.4 : 0.2), radius: earthActive[beadIndex] ? 4 : 2, x: 0, y: earthActive[beadIndex] ? 2 : 1)
                        .offset(y: earthActive[beadIndex] ? activeY : inactiveY)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                toggleEarthBead(at: beadIndex)
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 50)
    }
    
    private func toggleEarthBead(at index: Int) {
        let isCurrentlyActive = earthActive[index]
        if isCurrentlyActive {
            for i in index..<4 {
                earthActive[i] = false
            }
        } else {
            for i in 0...index {
                earthActive[i] = true
            }
        }
    }
}

struct BeadView: View {
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(width: 40, height: 26)

            // Main shine highlight
            RoundedRectangle(cornerRadius: 9)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(1.0), Color.white.opacity(0.8), Color.white.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 32, height: 16)
                .offset(y: -6)
            
            // Secondary highlight
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: 20, height: 8)
                .offset(x: -6, y: -8)
            
            // Inner shadow effect for depth
            RoundedRectangle(cornerRadius: 11.5)
                .stroke(
                    LinearGradient(
                        colors: [Color.black.opacity(0.4), Color.clear, Color.white.opacity(0.2)],
                        startPoint: .bottom,
                        endPoint: .top
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 39, height: 25)

            // Outer rim
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
                .frame(width: 40, height: 26)
        }
    }
}

#Preview {
    ContentView()
}
