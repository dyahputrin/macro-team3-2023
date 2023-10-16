//
//  DocumentView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 14/10/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct MessageDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }

    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
}

struct DocumentView: View {
    @Binding var document: MessageDocument

    var body: some View {
        VStack {
            GroupBox(label: Text("Message:")) {
                TextEditor(text: $document.message)
            }
        }
    }
}


#Preview {
    DocumentView(document: .constant(MessageDocument(message: "Hello, World!")))
}
