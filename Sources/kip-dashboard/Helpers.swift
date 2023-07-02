//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/19/23.
//

import Foundation

extension Configuration {
    static func locations( ordered: Bool = false) -> [Location] {
        let storesText: String
        if !ordered {
            storesText = """
        LCHVDQS909GPQ\tS1 - ILS4 / Mill Creek\tApr 19, 2022
        L208AAG3MR0A1\tS2 - ILS1 / Whittier\tSep 19, 2023
        LDEXERFMT41CP\tS3 - ILS3 / Torrance\tNov 1, 2022
        LVKKYXS44H0VM\tS4 - ILS2 / Woodland Hills\tDec 1, 2022
        LVB2TEKH5W0WK\tS5 - IWA3 / Frederickson\tFeb 14, 2023
        
        """
        } else {
            storesText = """
        LCHVDQS909GPQ\tS1 - ILS4 / Mill Creek\tApr 19, 2022
        LDEXERFMT41CP\tS3 - ILS3 / Torrance\tNov 1, 2022
        LVB2TEKH5W0WK\tS5 - IWA3 / Frederickson\tFeb 14, 2023
        L208AAG3MR0A1\tS2 - ILS1 / Whittier\tSep 19, 2023
        LVKKYXS44H0VM\tS4 - ILS2 / Woodland Hills\tDec 1, 2022
        
        """
        }
        
        let rows = storesText.split(separator: "\n")
        let body = rows.enumerated().compactMap { index, row in
            let fields = row.split(separator: "\t")
            if fields.count >= 2 {
                return Location(id: fields[0].asString, name: fields[1].asString, openedAt: fields[2].asString.asDate, index: index )
            }
            return nil
        }
        return body
    }
}