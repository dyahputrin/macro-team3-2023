//
//  BackRoot.swift
//  macro2023
//
//  Created by Billy Jefferson on 11/10/23.
//

import Foundation

class RouterView:ObservableObject{
    @Published var path:[String] = []
    @Published var project:ProjectEntity? = nil
    @Published var object:ObjectEntity? = nil
}
