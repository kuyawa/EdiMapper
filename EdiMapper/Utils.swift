//
//  Utils.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation


class Filer {
    static func exists(_ file: String) -> Bool {
        return true
    }
    
    static func toString(_ file: String) -> String {
        return ""
    }
    
    static func setExtension(_ file: String, _ ext: String) -> String {
        return ""
    }
}

extension Int {
    var string: String { return String(self) }
}

extension String {
    var length: Int { return characters.count }
    var trimmed: String { return trimmingCharacters(in: .whitespacesAndNewlines) }
    
    func substr(_ m: Int, _ n: Int) -> String {
        return ""
    }
    
    func locate(_ text: String, _ offset: Int = 0) -> Int {
        return 0
    }
    
    func replace(_ find: String, _ text: String) -> String {
        return ""
    }
    
    func padLeft(_ count: Int, _ chars: String = " ") -> String {
        return ""
    }
    
    func occurs(_ needle: String) -> Int {
        var offset   = 0
        var counter  = 0
        var position = 0
        
        while true {
            position = self.locate(needle, offset)
            if position < 0 { break }
            else {
                counter += 1
                offset = position + needle.length
            }
        }
        
        return counter
    }
    
    func occurIndex(_ needle: String, _ occurrence: Int) -> Int {
        var offset   = 0
        var counter  = 0
        var position = 0
        
        for _ in 0 ..< occurrence {
            position = self.locate(needle, offset)
            if position < 0 { break }
            else{
                counter += 1
                if counter == occurrence { return position }
                else { offset = position + needle.length }
            }
        }
        
        return -1 // We never found it if we reached here
    }

}

extension Date {
    func format(_ format: String) -> String {
        return ""
    }
}

// END
