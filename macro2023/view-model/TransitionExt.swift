//
//  TransitionExt.swift
//  macro2023
//
//  Created by Shalomeira Winata on 15/10/23.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}


