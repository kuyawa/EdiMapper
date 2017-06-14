//
//  Map210v4010.swift
//  EdiMapper
//
//  Created by Laptop on 6/14/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

/* 210 - FREIGHT INVOICE */

class map210v4010: EdiToXml {

    func Run() {
        NewGroup("ENVELOPE")
        Parse("ISA",mandatory)
        
        NewGroup("GROUP")
        Parse("GS" ,mandatory)
        
        CheckMandatory("ST")
        while(currentSegmentId=="ST") {
            NewGroup("TRANSACTION")
            Parse("ST",mandatory)
            Parse("B3",mandatory)
            Parse("C2")
            Parse("C3")
            Parse("ITD")
            Parse("N9")
            Parse("G62")
            Parse("R3")
            Parse("H3")
            Parse("K1")
            
            while(currentSegmentId=="N1") {
                NewGroup("LOOP","0100")
                Parse("N1")
                Parse("N2")
                Parse("N3")
                Parse("N4")
                Parse("N9")
                EndGroup()
            }
            
            while(currentSegmentId=="N7") {
                NewGroup("LOOP","0200")
                Parse("N7")
                Parse("M7")
                EndGroup()
            }

            while(currentSegmentId=="SPO") {
                NewGroup("LOOP","0250")
                Parse("SPO")
                Parse("SDQ")
                EndGroup()
            }
            
            while(currentSegmentId=="S5") {
                NewGroup("LOOP","0300")
                Parse("S5")
                Parse("N9")
                Parse("G62")
                Parse("H3")

                while(currentSegmentId=="SPO") {
                    NewGroup("LOOP","0305")
                    Parse("SPO")
                    Parse("SDQ")
                    EndGroup()
                }
                
                while(currentSegmentId=="N1") {
                    NewGroup("LOOP","0310")
                    Parse("N1")
                    Parse("N2")
                    Parse("N3")
                    Parse("N4")
                    Parse("N9")
                    
                    while(currentSegmentId=="N7") {
                        NewGroup("LOOP","0320")
                        Parse("N7")
                        Parse("M7")
                        EndGroup()
                    }
                    EndGroup()
                }
                EndGroup()
            }
            
            while(currentSegmentId=="LX") {
                NewGroup("LOOP","0400")
                Parse("LX")
                Parse("N9")
                Parse("POD")
                Parse("L5")
                Parse("H1")
                Parse("H2")
                Parse("L0")
                Parse("L1")
                Parse("L4")
                Parse("L7")
                Parse("K1")
                
                while(currentSegmentId=="SPO") {
                    NewGroup("LOOP","0430")
                    Parse("SPO")
                    Parse("SDQ")
                    EndGroup()
                }

                while(currentSegmentId=="N1") {
                    NewGroup("LOOP","0460")
                    Parse("N1")
                    Parse("N2")
                    Parse("N3")
                    Parse("N4")
                    Parse("N9")
                    
                    while(currentSegmentId=="CD3") {
                        NewGroup("LOOP","0463")
                        Parse("CD3")
                        Parse("N9")
                        Parse("H6")
                        Parse("L9")
                        Parse("POD")
                        Parse("G62")
                        EndGroup()
                    }
                    
                    while(currentSegmentId=="SPO") {
                        NewGroup("LOOP","0465")
                        Parse("SPO")
                        Parse("SDQ")
                        EndGroup()
                    }
                    EndGroup()
                }
                EndGroup()
            }
            
            Parse("L3")
            Parse("SE",mandatory)
            EndGroup()
        }
        
        Parse("GE",mandatory)
        EndGroup()
        
        Parse("IEA",mandatory)
        EndGroup()
        
        Save()
        return
    }
}


// END
