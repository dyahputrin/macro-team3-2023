//
//  SceneObjectModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 30/10/23.
//

import Foundation
import SceneKit

class SceneObjectModel: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true

    var id: String?
    var position: SCNVector3?
    var rotation: SCNQuaternion?
    
    // Initializer
    init(id: String?, position: SCNVector3?,  rotation: SCNQuaternion?) {
        self.id = id
        self.position = position
        self.rotation = rotation
    }
    
    // MARK: - NSCoding
    
    // This is the initializer that will be called when an object is unarchived
    required init?(coder aDecoder: NSCoder) {
        // Decoding the 'id' property, if it exists
        id = aDecoder.decodeObject(of: NSString.self, forKey: "id") as String?
        
        // Decoding the 'position' property, if it exists
        if let positionArray = aDecoder.decodeObject(of: [NSArray.self, NSNumber.self], forKey: "position") as? [Float], positionArray.count == 3 {
            position = SCNVector3(positionArray[0], positionArray[1], positionArray[2])
        }
        
        // Decoding the 'rotation' property, if it exists
//        if let rotationArray = aDecoder.decodeObject(of: [NSArray.self, NSNumber.self], forKey: "rotation") as? [Float], rotationArray.count == 4 {
//            rotation = SCNVector4(rotationArray[0], rotationArray[1], rotationArray[2], rotationArray[3])
//        }
        if let rotationArray = aDecoder.decodeObject(of: [NSArray.self, NSNumber.self], forKey: "rotation") as? [Float], rotationArray.count == 4 {
                    rotation = SCNQuaternion(rotationArray[0], rotationArray[1], rotationArray[2], rotationArray[3])
                }
    }
    
    // This is the method that will be called when an object is archived
    func encode(with aCoder: NSCoder) {
        // Encoding the 'id' property
        aCoder.encode(id, forKey: "id")
        
        // Encoding the 'position' property
        if let position = position {
            aCoder.encode([position.x, position.y, position.z], forKey: "position")
        }
        
        // Encoding the 'rotation' property
//        if let rotation = rotation {
//            aCoder.encode([rotation.x, rotation.y, rotation.z, rotation.w], forKey: "rotation")
//        }
        if let rotation = rotation {
                    aCoder.encode([rotation.x, rotation.y, rotation.z, rotation.w], forKey: "rotation")
                }
    }
}



