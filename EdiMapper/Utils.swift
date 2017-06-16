//
//  Utils.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation


class Filer {
    static func toString(_ file: String) -> String {
        let url = URL(string: file)!
        let text = try? String(contentsOf: url)
        return text ?? ""
    }
    
    static func toString(_ url: URL) -> String {
        let text = try? String(contentsOf: url)
        return text ?? ""
    }
    
    static func save(_ fileName: String, _ contents: String) {
        try? contents.write(toFile: fileName, atomically: false, encoding: .utf8)
    }
    
    static func exists(_ file: String) -> Bool {
        // TODO
        return true
    }
    
    static func setExtension(_ file: String, _ ext: String) -> String {
        // TODO
        return ""
    }
}

extension Int {
    var string: String { return String(self) }
    
    // Inclusive
    func inRange(_ min: Int, _ max: Int) -> Bool {
        if self >= min && self <= max { return true }
        return false
    }
    
}

extension String {
    var length: Int { return characters.count }
    var trimmed: String { return trimmingCharacters(in: .whitespacesAndNewlines) }
    
    subscript (i: Int) -> String {
        if self.isEmpty || i > self.length { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript (i: Int, j: Int) -> String {
        if self.isEmpty { return "" }
        if i > self.length { return "" }
        if j < i { return "" }
        if j > self.length { return self[range(i, self.length)] }
        return self[range(i, j)]
    }
    
    subscript (r: Range<Int>) -> String {
        let ini = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(ini ..< end)]
    }
    
    func range(_ lo: Int, _ hi: Int) -> Range<String.Index> {
        let ini = index(startIndex, offsetBy: lo)
        let end = index(startIndex, offsetBy: hi)
        return Range(ini ..< end)
    }

    func substr(_ m: Int, _ n: Int) -> String {
        return self[m, n]
    }
    
    func locate(_ text: String, _ occurrence: Int = 1) -> Int {
        var count  = 0
        var result = 0
        var start  = startIndex
        
        while let range = range(of: text, options: .literal, range: start..<endIndex) {
            result = self.distance(from: startIndex, to: range.lowerBound)
            start = range.upperBound
            count += 1
            if count == occurrence { return result }
        }
        
        return -1
    }
    
    func replace(_ find: String, _ text: String) -> String {
        return self.replacingOccurrences(of: find, with: text)
    }
    
    func padRight(_ n: Int, _ chars: String = " ") -> String {
        var text = self
        let size = self.characters.count
        var pad  = n - size
        
        if pad < 0 { pad = 0 }
        
        for _ in 0 ..< pad {
            text = text + chars
        }
        
        return text
    }
    
    func padLeft(_ n: Int, _ chars: String = " ") -> String {
        var text = self
        let size = self.characters.count
        var pad  = n - size
        
        if pad < 0 { pad = 0 }
        
        for _ in 0 ..< pad {
            text = chars + text
        }
        
        return text
    }
    
    func occurs(_ text: String) -> Int {
        var count = 0
        var start = startIndex
        
        while let range = range(of: text, options: .literal, range: start..<endIndex) {
            start = range.upperBound
            count += 1
        }
        
        return count
    }

    func occurs2(_ needle: String) -> Int {
        return self.components(separatedBy: needle).count - 1
    }

}

extension Date {
    func toString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    static func fromString(_ text: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        if !text.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            if let date = formatter.date(from: text) {
                return date
            }
        }
        
        return nil
    }
    
}

// END
