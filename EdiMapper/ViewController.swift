//
//  ViewController.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }

    func start() {
        //test210()
        test810()
    }
    
    func test210() {
        let url = Bundle.main.url(forResource: "Sample210v4010", withExtension: "txt")!
        //print("Url: ", url)
        //let text = Filer.toString(url)
        //print("Text: ", text)
        let edi = Map210v4010()
        edi.Load(url)
        edi.Run()
    }
    
    func test810() {
        let url = Bundle.main.url(forResource: "Sample810v4010", withExtension: "txt")!
        let edi = Map810v4010()
        edi.Load(url)
        edi.Run()
    }
    
    func test2() {
        let x = "761,23.45,76.789..76"
        print(x.occurs("."))
        print(x.occurs(","))
        print(x.occurs(":"))
        print(x.occurs("789"))
        print(x.occurs("76"))
    }
}

