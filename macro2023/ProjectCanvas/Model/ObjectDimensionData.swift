//
//  ObjectDimensionData.swift
//  macro2023
//
//  Created by Jefry Gunawan on 26/10/23.
//

import Foundation

class ObjectDimensionData: ObservableObject {
    @Published var name: String
    @Published var length: String
    @Published var width: String
    @Published var height: String
    
    init() {
        self.name = "--"
        self.length = "--"
        self.width = "--"
        self.height = "--"
    }
    
    func reset() {
        self.name = "--"
        self.length = "--"
        self.width = "--"
        self.height = "--"
    }
}
