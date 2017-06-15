//
//  EdiToXml.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

/* USE:
 
    edi = EdiToXml()
    edi.Convert(ediFileName, ediMapName)
    edi.Save(xmlFileName)
    print(edi.xml)
 
*/

class EdiToXml {

    let mandatory  = true
    let optional   = false

    var timeStamp         = ""
    var endOfFile         = false
    var ediContent        = ""
    var ediLines          = [String]()
    var separator         = ""
    var terminator        = ""
    var currentSegment    = ""
    var currentSegmentId  = ""
    var previousSegmentId = ""
    var segmentCounter    =  0
    var currentLine       = -1
    var linesCount        =  0

    var tagStack = [String]()
    var writer = XmlWriter()
    
    @discardableResult
    func Load(_ url: URL) -> Bool {
        let fileName = url.path
        if !Filer.exists(fileName) { return false }
        self.ediContent = Filer.toString(url)
        let xmlFileName = Filer.setExtension(fileName, "xml")
        
        // Check first segment ISA
        if self.ediContent[0,3] != "ISA" {
            LogError("ISA segment required!")
            return false
        }
        
        // Get element separator and segment terminator
        self.separator  = self.getSeparator()
        self.terminator = self.getTerminator()
        if self.terminator == "" {
            LogError("Terminator required!")
            return false
        }
        
        // Split content in lines per terminator
        self.ediLines   = self.ediContent.components(separatedBy: self.terminator)
        self.linesCount = self.ediLines.count
        
        self.Initialize(xmlFileName)
        self.NextSegment() // read first segment
        
        return true
    }
    
    func Save() {
        // TODO:
        //self.writer.Close()
    }
    
    func Initialize(_ fileName: String) {
        self.writer = XmlWriter(fileName) // TODO
        self.currentSegment   = ""
        self.currentSegmentId = ""
        self.currentLine      = -1
        self.endOfFile        = false
        self.timeStamp        = Date().toString()
    }
    
    func getSeparator() -> String {
        if self.ediContent == "" { return "" }
        else { return self.ediContent[3,4] }
    }
    
    func getTerminator() -> String {
        var ini = 0
        var end = 0
        var extract = ""
        
        ini = self.ediContent.locate(self.separator, 16) + 1
        extract = self.ediContent[ini+1, ini+7]        // sample 6 chars after ISA's end
        let group = "GS"+self.separator
        end = extract.locate(group)                    // terminator ends where GS starts
        if end < 0 { return "" }                       // GS segment not present, file unreadable.
        
        extract = extract[0, end]
        //if extract.length > 1 {
        //    self.ediContent = self.ediContent.replace(extract, "\n")
        //    extract = "\n"
        //}
        
        return extract
    }
    
    @discardableResult
    func Parse(_ segmentId: String, _ isMandatory: Bool = false) -> Bool {
        if isMandatory && !self.CheckMandatory(segmentId) {
            self.LogError("Mandatory segment: "+segmentId)
            return false
        }
        
        if segmentId != self.currentSegmentId { return false }
    
        while segmentId == self.currentSegmentId && !self.endOfFile {
            self.ParseSegment(segmentId)
            self.NextSegment()
        }
        
        return true
    }
    
    func NewGroup(_ tagName: String, _ loopId: String = "") {
        tagStack.append(tagName)
        self.writer.WriteStartElement(tagName)
        if !loopId.isEmpty {
            self.writer.WriteAttributeString("id", loopId)
        }
        self.writer.WriteClosingBracket()
        return
    }
    
    func EndGroup() {
        let tagName = tagStack.popLast()!
        self.writer.WriteClosingTag(tagName)
        //self.writer.WriteEndElement()
        return
    }
    
    @discardableResult
    func CheckMandatory(_ segmentId: String) -> Bool {
        if segmentId == self.currentSegmentId { return true }
    
        self.LogError("Mandatory segment "+self.currentSegmentId+" not found")
        while self.currentLine <= self.linesCount { self.NextSegment() }
        self.currentSegmentId = "EOF"
        //Error = true
        return false
    }
    
    func NextSegment() {
        self.currentLine += 1
        if self.currentLine >= self.linesCount {
            self.currentLine = self.linesCount
            self.endOfFile = true
            return
        }
    
        self.previousSegmentId = self.currentSegmentId
        self.currentSegment    = self.ediLines[currentLine]
    
        let position = self.currentSegment.locate(self.separator)
        if position < 0 { self.currentSegmentId = self.currentSegment.trimmed }    // Empty Line
        else { self.currentSegmentId = self.currentSegment[0, position] }
    }
    
    func ParseSegment(_ segmentId: String) {
        let elements = self.currentSegment.occurs(self.separator)
        var anyName  = ""
        var anyValue = ""
        
        self.writer.WriteStartElement(segmentId)
        for index in 0 ..< elements {
            anyValue = self.ReadElement(index+1)
            if anyValue == "" { continue }
        
            if anyValue.locate("&")  >= 0 ||
               anyValue.locate(">")  >= 0 ||
               anyValue.locate("<")  >= 0 ||
               anyValue.locate("\"") >= 0 ||
               anyValue.locate("'")  >= 0 {
                anyValue = anyValue.replace("&" ,"&amp;" )
                anyValue = anyValue.replace(">" ,"&gt;"  )
                anyValue = anyValue.replace("<" ,"&lt;"  )
                anyValue = anyValue.replace("'" ,"&apos;")
                anyValue = anyValue.replace("\"","&quot;")
            }
            anyName = "e" + (index+1).string.padLeft(2, "0")
            self.writer.WriteAttributeString(anyName,anyValue)
        }
        
        self.writer.WriteEndElement()
    }
    
    func ReadElement(_ position: Int) -> String {
        var anyValue = ""
        var nIni = self.currentSegment.locate(self.separator, position)
        var nEnd = self.currentSegment.locate(self.separator, position+1)
        
        if nIni < 0 { return "" } else { nIni += 1 }
        if nEnd < 0 { nEnd = self.currentSegment.length }
        anyValue = self.currentSegment[nIni, nEnd]
        
        return anyValue
    }
    
    func LogError(_ message: String) {
        print("Error: ", message)
    }
}


