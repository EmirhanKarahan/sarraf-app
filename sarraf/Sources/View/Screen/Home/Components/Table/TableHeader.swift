//
//  TableHeader.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

struct TableHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Ürün")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Alış")
                .frame(width: 85, alignment: .trailing)
            Text("Satış")
                .frame(width: 85, alignment: .trailing)
            Text("% 24s")
                .frame(width: 70, alignment: .trailing)
        }
        .font(.system(size: 16))
        .foregroundColor(.secondary)
        .frame(height: 40)
    }
}
