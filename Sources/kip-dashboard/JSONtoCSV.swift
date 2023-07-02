//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/20/23.
//

import Foundation
import JSON
import Tagged

public enum CSV { }
public typealias CSVJSON = Tagged<CSV, JSON>


#if canImport(AppKit)

func jsonToCsv(jsonArray: [JSON], includeHeader: Bool = true ) throws -> String {
    // Extract headers
//    let headers = try jsonArray.map { CSVJSON(rawValue:  $0).extractHeaders() }
//        .sorted { a, b in
//            a.count > b.count
//        }.first.unwrapped().sorted()
    
    let headers = "placedToCompletion,claimedToCompletion,catalogId,name,modifiers,locationId,placedAt,timeOfDay,hot,modifier1Id,modifier1Name,modifier2Id,modifier2Name,modifier3Id,modifier3Name,modifier4Id,modifier4Name,modifier5Id,modifier5Name,modifier6Id,modifier6Name,modifier7Id,modifier7Name,modifier8Id,modifier8Name,modifier9Id,modifier9Name,modifier10Id,modifier10Name,placedAtPacificDayOfWeek".split(separator: ",").map(String.init)
    // Create CSV string
    
    var csv = includeHeader ? headers.joined(separator: ",") + "\n" : ""
    for json in jsonArray {
        let row = headers.map { extractValue(from: json, forHeader: $0) ?? "" }
        csv += row.joined(separator: ",") + "\n"
    }
    return csv
}

private func extractValue(from json: JSON, forHeader header: String) -> String? {
    let keys = header.split(separator: ".").map(String.init)
    return extractValueHelper(from: json, keys: Array(keys))
}

private func extractValueHelper(from json: JSON, keys: [String]) -> String? {
    guard !keys.isEmpty else { return nil }
    if keys.count == 1 {
        // This is the key we're looking for
        return json[keys[0]].scalarValueToString() ?? ""
    } else {
        // We need to dig deeper
        if let jsonObject = json[keys[0]].object {
            let subJson = JSON(jsonObject)
            return extractValueHelper(from: subJson, keys: Array(keys.dropFirst()))
        }
    }
    return nil
}
extension CSVJSON {
    func extractHeaders() -> Array<String> {
        var headers = Array<String>()
        extractHeadersHelper(parentKey: nil, headers: &headers)
        return headers
    }
    
    private func extractHeadersHelper( parentKey: String?, headers: inout Array<String>) {
        if let jsonObject = self.rawValue.object {
            for (key, value) in jsonObject {
                let newKey = parentKey != nil ? "\(parentKey!).\(key)" : key
                if value.object != nil {
                    // For nested objects, we recurse
                    CSVJSON(rawValue: value).extractHeadersHelper( parentKey: newKey, headers: &headers)
                } else {
                    // This is a leaf node, so we add it to the headers
                    headers.append(newKey)
                }
            }
        } else if let jsonArray: [JSON] = json.array {
            for jsonElement in jsonArray {
                CSVJSON(rawValue: jsonElement).extractHeadersHelper( parentKey: parentKey, headers: &headers)
            }
        }
    }
}

extension JSON {
    func scalarValueToString() -> String? {
        if self.isString {
            if let strValue = string, strValue.contains(",") {
                return "\"\(strValue)\""
            }
            return self.string
        } else if self.isNumber || isFloat || isDouble || isInt {
            return self.float?.description ?? self.int?.description ?? self.double?.description ?? self.decimal?.description ?? ""
        } else if self.isBool {
            return self.bool?.description
        } else if self.isNull {
            return "null"
        } else {
            return nil
        }
    }
}
#endif
