//
//  Map810v4010.swift
//  EdiMapper
//
//  Created by Laptop on 6/15/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

/* 810 - INVOICE */

class Map810v4010: EdiToXml {
    
    override func convert() {
        newGroup("ENVELOPE")
        parse("ISA",mandatory)
        
        checkMandatory("GS")
        while(currentSegmentId=="GS") {
            newGroup("GROUP")
            parse("GS",mandatory)
            
            checkMandatory("ST")
            while(currentSegmentId=="ST") {
                newGroup("TRANSACTION")
                parse("ST",mandatory)
                parse("BIG")
                parse("CUR")
                parse("NTE")
                parse("REF")

                while(currentSegmentId=="N1") {
                    newGroup("LOOP","0100")
                    parse("N1",optional,max:1)
                    parse("N2")
                    parse("N3")
                    parse("N4")
                    parse("N9")
                    endGroup()
                }

                parse("ITD")
                parse("DTM")
                parse("FOB")
                parse("BAL")
                parse("PAM")

                while(currentSegmentId=="IT1") {
                    newGroup("LOOP","0200")
                    parse("IT1",optional,max:1)
                    parse("DTM")
                    parse("CTP")
                    
                    while(currentSegmentId=="PID") {
                        newGroup("LOOP","0300")
                        parse("PID",optional,max:1)
                        endGroup()
                    }
                    
                    parse("REF")
                    //parse("PO4")
                    
                    while(currentSegmentId=="SAC") {
                        newGroup("LOOP","0400")
                        parse("SAC",optional,max:1)
                        endGroup()
                    }
                    
                    while(currentSegmentId=="SLN") {
                        newGroup("LOOP","0500")
                        parse("SLN",optional,max:1)
                        parse("PID")
                        endGroup()
                    }
                    
                    endGroup()
                }

                parse("TDS")
                parse("TXI")
                parse("CAD")

                while(currentSegmentId=="SAC") {
                    newGroup("LOOP","0600")
                    parse("SAC",optional,max:1)
                    endGroup()
                }

                parse("CTT")
                parse("ISS")
                parse("SE",mandatory)
                endGroup()
            }
        
            parse("GE",mandatory)
            endGroup()
        }
        
        parse("IEA",mandatory)
        endGroup()
        
        return
    }
}
