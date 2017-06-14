//
//  XmlWriter.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

class XmlWriter {
    var fileName = ""
    
    init() {}
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    func WriteStartElement(_ tag: String) {
        //
    }
    
    func WriteEndElement() {
        //
    }
    
    func WriteAttributeString(_ name: String, _ value: String) {
        //
    }
}
