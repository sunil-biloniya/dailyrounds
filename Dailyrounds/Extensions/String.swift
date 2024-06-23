//
//  String.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func makeURL() -> URL? {
       return URL(string: self)
    }
    
    func trims() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
