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
    
    func Run() {
        NewGroup("ENVELOPE")
        Parse("ISA",mandatory)
        
        NewGroup("GROUP")
        Parse("GS",mandatory)
        
        CheckMandatory("ST")
        while(currentSegmentId=="ST") {
            NewGroup("TRANSACTION")
            Parse("ST",mandatory)
            Parse("BIG")
            Parse("CUR")
            Parse("REF")

            while(currentSegmentId=="N1") {
                NewGroup("LOOP","0100")
                Parse("N1")
                Parse("N2")
                Parse("N3")
                Parse("N4")
                Parse("N9")
                EndGroup()
            }

            Parse("ITD")
            Parse("DTM")
            Parse("FOB")

            while(currentSegmentId=="IT1") {
                NewGroup("LOOP","0200")
                Parse("IT1")
                Parse("CTP")
                
                while(currentSegmentId=="PID") {
                    NewGroup("LOOP","0300")
                    Parse("PID")
                    EndGroup()
                }
                
                Parse("REF")
                //Parse("PO4")
                
                while(currentSegmentId=="SAC") {
                    NewGroup("LOOP","0400")
                    Parse("SAC")
                    EndGroup()
                }
                
                while(currentSegmentId=="SLN") {
                    NewGroup("LOOP","0500")
                    Parse("SLN")
                    Parse("PID")
                    EndGroup()
                }
                
                EndGroup()
            }

            Parse("TDS")
            Parse("TXI")
            Parse("CAD")

            while(currentSegmentId=="SAC") {
                NewGroup("LOOP","0400")
                Parse("SAC")
                EndGroup()
            }

            Parse("CTT")
            Parse("ISS")
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
