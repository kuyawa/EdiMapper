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
    var content  = "<?xml version=\"1.0\" ?>\n"
    var indent   = 0
    var tab      = "    "
    
    init() {
        //
    }
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    func writeStartElement(_ tag: String) {
        let line   = String(repeating: tab, count: indent) + "<" + tag
        self.content += line
    }

    func writeEndElement() {
        let line = " />\n"
        self.content += line
    }
    
    func writeClosingBracket() {
        let line = ">\n"
        self.content += line
    }
    
    func writeClosingTag(_ tag: String) {
        let line = String(repeating: tab, count: indent) + "</\(tag)>\n"
        self.content += line
    }
    
    func writeAttributeString(_ name: String, _ value: String) {
        let line = " \(name)=\"\(value)\""
        self.content += line
    }

    func append(_ xml: String) {
        self.content += xml
    }
    
    func save() {
        // TODO:
        //print("Writing file...")
        //Filer.save(self.fileName, self.content)
    }

}
