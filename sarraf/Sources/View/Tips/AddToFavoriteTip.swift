//
//  AddToFavoriteTip.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 25.10.2025.
//

import SwiftUI
import TipKit

struct AddToFavoriteTip: Tip {
    var title: Text { Text("Favoriye ekleme") }
    var message: Text? { Text("Bir emtiayı favorilerinize eklemek için ürünlere basılı tutun") }
    var image: Image? { Image(systemName: "heart") }
    var options: [Option] {
         Tips.MaxDisplayCount(1)
     }
}
