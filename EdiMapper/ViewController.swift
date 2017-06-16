//
//  ViewController.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textEDI: NSTextView!
    @IBOutlet var textXML: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maxFloat = CGFloat(Float.greatestFiniteMagnitude)
        let maxSize  = NSMakeSize(maxFloat, maxFloat)
        
        // Make textviews scroll horizontally
        textEDI.font = NSFont(name: "Menlo", size: 14.0)
        textEDI.maxSize = maxSize
        textEDI.isHorizontallyResizable = true
        textEDI.textContainer?.widthTracksTextView = false
        textEDI.textContainer?.containerSize = maxSize
        
        textXML.font = NSFont(name: "Menlo", size: 14.0)
        textXML.maxSize = maxSize
        textXML.isHorizontallyResizable = true
        textXML.textContainer?.widthTracksTextView = false
        textXML.textContainer?.containerSize = maxSize
        
        start()
    }

    func start() {
        //test210()
        test810()
    }
    
    func test210() {
        let url = Bundle.main.url(forResource: "Sample210v4010", withExtension: "txt")!
        let edi = Map210v4010()
        edi.load(url)
        edi.convert()
        textEDI.string = (try? String(contentsOf: url)) ?? "?"
        textXML.string = edi.xml
    }
    
    func test810() {
        let url = Bundle.main.url(forResource: "Sample810v4010", withExtension: "txt")!
        let edi = Map810v4010()
        edi.load(url)
        edi.convert()
        textEDI.string = (try? String(contentsOf: url)) ?? "?"
        textXML.string = edi.xml
    }
    
}

