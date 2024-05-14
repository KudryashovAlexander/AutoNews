//
//  DateFormatter_ext..swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import Foundation

extension Date {
    
    func createDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: string)
    }
    
    func createString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }
    
}
