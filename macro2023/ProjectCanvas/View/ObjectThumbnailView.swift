//
//  ObjectThumbnailView.swift
//  macro2023
//
//  Created by Billy Jefferson on 30/10/23.
//

import SwiftUI

struct ObjectThumbnailView: View {
    let objectEntity: ObjectEntity
    
    var body: some View {
        if let thumbnailData = objectEntity.importedPreview,
           let uiImage = UIImage(data: thumbnailData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .background(Color.blue)
        } else {
            Text("No Thumbnail Available") // You can customize this message
        }
    }
}

