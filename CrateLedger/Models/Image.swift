//
//  Image.swift
//  CrateLedger
//
//  Created by Bruno Carvalho on 26/04/2025.
//

import Foundation
import SwiftData

@Model
class Image {
    var thumb: String = "";
    var small: String = "";
    var large: String = "";
    var owner: Asset?
    
    init(thumb: String, small: String, large: String, owner: Asset? = nil) {
        self.thumb = thumb
        self.small = small
        self.large = large
        self.owner = owner
    }
}
