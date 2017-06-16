//
//  Map210v4010.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

/* 210 - FREIGHT INVOICE */

class Map210v4010: EdiToXml {

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
                parse("B3",mandatory)
                parse("C2")
                parse("C3")
                parse("ITD")
                parse("N9")
                parse("G62")
                parse("R3")
                parse("H3")
                parse("K1")
                
                while(currentSegmentId=="N1") {
                    newGroup("LOOP","0100")
                    parse("N1")
                    parse("N2")
                    parse("N3")
                    parse("N4")
                    parse("N9")
                    endGroup()
                }
                
                while(currentSegmentId=="N7") {
                    newGroup("LOOP","0200")
                    parse("N7")
                    parse("M7")
                    endGroup()
                }

                while(currentSegmentId=="SPO") {
                    newGroup("LOOP","0250")
                    parse("SPO")
                    parse("SDQ")
                    endGroup()
                }
                
                while(currentSegmentId=="S5") {
                    newGroup("LOOP","0300")
                    parse("S5")
                    parse("N9")
                    parse("G62")
                    parse("H3")

                    while(currentSegmentId=="SPO") {
                        newGroup("LOOP","0305")
                        parse("SPO")
                        parse("SDQ")
                        endGroup()
                    }
                    
                    while(currentSegmentId=="N1") {
                        newGroup("LOOP","0310")
                        parse("N1")
                        parse("N2")
                        parse("N3")
                        parse("N4")
                        parse("N9")
                        
                        while(currentSegmentId=="N7") {
                            newGroup("LOOP","0320")
                            parse("N7")
                            parse("M7")
                            endGroup()
                        }
                        endGroup()
                    }
                    endGroup()
                }
                
                while(currentSegmentId=="LX") {
                    newGroup("LOOP","0400")
                    parse("LX")
                    parse("N9")
                    parse("POD")
                    parse("L5")
                    parse("H1")
                    parse("H2")
                    parse("L0")
                    parse("L1")
                    parse("L4")
                    parse("L7")
                    parse("K1")
                    
                    while(currentSegmentId=="SPO") {
                        newGroup("LOOP","0430")
                        parse("SPO")
                        parse("SDQ")
                        endGroup()
                    }

                    while(currentSegmentId=="N1") {
                        newGroup("LOOP","0460")
                        parse("N1")
                        parse("N2")
                        parse("N3")
                        parse("N4")
                        parse("N9")
                        
                        while(currentSegmentId=="CD3") {
                            newGroup("LOOP","0463")
                            parse("CD3")
                            parse("N9")
                            parse("H6")
                            parse("L9")
                            parse("POD")
                            parse("G62")
                            endGroup()
                        }
                        
                        while(currentSegmentId=="SPO") {
                            newGroup("LOOP","0465")
                            parse("SPO")
                            parse("SDQ")
                            endGroup()
                        }
                        endGroup()
                    }
                    endGroup()
                }
                
                parse("L3")
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


// END
