//
//  Date+EXT.swift
//  GHFollowers
//
//  Created by user on 14/07/2026.
//
import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
}
