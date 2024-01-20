//
//  Date+Ext.swift
//  GiftView
//
//  Created by Connor Hammond on 8/21/23.
//

import Foundation

extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    func addingYears(_ years: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: years, to: self)
    }
}
