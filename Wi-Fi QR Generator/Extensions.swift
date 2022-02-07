//
//  Extensions.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 7/02/22.
//

import Foundation

extension String {


    
    
    var stripped: String {
        let okayChars = Set(" +-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}
