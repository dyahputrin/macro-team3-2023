//
//  RoomSidebarTip.swift
//  macro2023
//
//  Created by Oey Darryl Valencio Wijaya on 15/11/23.
//

import SwiftUI
import TipKit

struct RoomSidebarTip: Tip {
    var title: Text {
        Text("Create Your Room")
    }


    var message: Text? {
        Text("You can create your room by set your room size.")
    }


    var image: Image? {
        Image(systemName: "square.split.bottomrightquarter")
    }
}

struct RoomNavbarTip: Tip {
    var title: Text {
        Text("Close Sidebar")
    }


    var message: Text? {
        Text("You can close the sidebar by clicking the Room Icon.")
    }


    var image: Image? {
        Image(systemName: "square.split.bottomrightquarter")
    }
}
//#Preview {
//    RoomSidebarTip()
//}
