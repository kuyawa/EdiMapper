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
    var content  = ""
    
    init() {
        //
    }
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    func WriteStartElement(_ tag: String) {
        //let indent = 0 // TODO: Keep track of indent
        let line   = "<" + tag
        self.content += line
        print(line)
    }

    func WriteClosingBracket() {
        let line = ">\n"
        self.content += line
        print(line)
    }
    
    func WriteClosingTag(_ tag: String) {
        let line = "</\(tag)>"
        self.content += line
        print(line)
    }
    
    func WriteEndElement() {
        let line = " />\n"
        self.content += line
        print(line)
    }
    
    func WriteAttributeString(_ name: String, _ value: String) {
        let line = "\(name)=\"\(value)\""
        self.content += line
        print(line)
    }

    func Append(_ xml: String) {
        self.content += xml
    }
    
    func Close() {
        // ???
    }

    func Save() {
        Filer.save(self.fileName, self.content)
        print("WRITING FILE:")
    }

}
