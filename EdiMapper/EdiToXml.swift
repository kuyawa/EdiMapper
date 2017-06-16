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
    edi.load(ediFileName)
    edi.convert()
    edi.save()
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
    
    var xml: String { return writer.content }
    
    @discardableResult
    func load(_ url: URL) -> Bool {
        let fileName = url.path
        if !Filer.exists(fileName) { return false }
        ediContent = Filer.toString(url)
        let xmlFileName = Filer.setExtension(fileName, "xml")
        
        // Check first segment ISA
        if ediContent[0,3] != "ISA" {
            logError("ISA segment required!")
            return false
        }
        
        // Get element separator and segment terminator
        separator  = getSeparator()
        terminator = getTerminator()
        if terminator == "" {
            logError("Terminator required!")
            return false
        }
        
        // Split content in lines per terminator
        ediLines   = ediContent.components(separatedBy: terminator)
        linesCount = ediLines.count
        
        initialize(xmlFileName)
        nextSegment() // read first segment
        
        return true
    }
    
    func save() {
        // TODO:
    }
    
    func convert() {
        // Implement on mapper class
    }
    
    func initialize(_ fileName: String) {
        writer = XmlWriter(fileName)
        currentSegment   = ""
        currentSegmentId = ""
        currentLine      = -1
        endOfFile        = false
        timeStamp        = Date().toString()
    }
    
    func getSeparator() -> String {
        if ediContent == "" { return "" }
        else { return ediContent[3,4] }
    }
    
    func getTerminator() -> String {
        var ini = 0
        var end = 0
        var chars = ""
        
        ini = ediContent.locate(separator, 16) + 1
        chars = ediContent[ini+1, ini+7]   // sample 6 chars after ISA's end
        let group = "GS"+separator
        end = chars.locate(group)          // terminator ends where GS starts
        if end < 0 { return "" }           // GS segment not present, file unreadable.
        chars = chars[0, end]
        
        return chars
    }
    
    @discardableResult
    func parse(_ segmentId: String, _ isMandatory: Bool = false, max: Int? = nil) -> Bool {
        if isMandatory && !checkMandatory(segmentId) {
            logError("Mandatory segment: "+segmentId)
            return false
        }
        
        if segmentId != currentSegmentId { return false }
    
        var count = 0
        while segmentId == currentSegmentId && !endOfFile {
            parseSegment(segmentId)
            nextSegment()
            count += 1
            if max != nil && count >= max! { break }
        }
        
        return true
    }
    
    func newGroup(_ tagName: String, _ loopId: String = "") {
        tagStack.append(tagName)
        writer.writeStartElement(tagName)
        if !loopId.isEmpty {
            writer.writeAttributeString("id", loopId)
        }
        writer.writeClosingBracket()
        writer.indent += 1
        return
    }
    
    func endGroup() {
        writer.indent -= 1
        let tagName = tagStack.popLast()!
        writer.writeClosingTag(tagName)
        return
    }
    
    @discardableResult
    func checkMandatory(_ segmentId: String) -> Bool {
        if segmentId == currentSegmentId { return true }
        logError("Mandatory segment \(currentSegmentId) not found")
        while currentLine <= linesCount { nextSegment() }
        currentSegmentId = "EOF"
        return false
    }
    
    func nextSegment() {
        currentLine += 1
        if currentLine >= linesCount {
            currentLine = linesCount
            endOfFile = true
            return
        }
    
        previousSegmentId = currentSegmentId
        currentSegment    = ediLines[currentLine]
    
        let position = currentSegment.locate(separator)
        if position < 0 { currentSegmentId = currentSegment.trimmed }    // Empty Line
        else { currentSegmentId = currentSegment[0, position] }
    }
    
    func parseSegment(_ segmentId: String) {
        let elements = currentSegment.occurs(separator)
        var anyName  = ""
        var anyValue = ""
        
        writer.writeStartElement(segmentId)
        for index in 0 ..< elements {
            anyValue = readElement(index+1)
            if anyValue == "" { continue }
        
            // Replace xml entities
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
            writer.writeAttributeString(anyName,anyValue)
        }
        
        writer.writeEndElement()
    }
    
    func readElement(_ position: Int) -> String {
        var anyValue = ""
        var nIni = currentSegment.locate(separator, position)
        var nEnd = currentSegment.locate(separator, position+1)
        
        if nIni < 0 { return "" } else { nIni += 1 }
        if nEnd < 0 { nEnd = currentSegment.length }
        anyValue = currentSegment[nIni, nEnd]
        
        return anyValue.trimmed
    }
    
    func logError(_ message: String) {
        print("Error: ", message)
    }
}


