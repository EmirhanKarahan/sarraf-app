//
//  AmountPicker.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 12.10.2025.
//

import SwiftUI

struct AmountPicker: View {
    @Binding var amount: Double
    
    var body: some View {
        Picker("Miktar", selection: $amount) {
            ForEach(1...100, id: \.self) { number in
                Text("\(number)")
                    .tag(Double(number))
                    .padding(8)
            }
        }
    }
}
