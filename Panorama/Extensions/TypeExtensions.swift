//
//  DateExtensions.swift
//  Panorama
//
//  Created by riddinuz on 7/17/22.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension String {
    func convertDateFormat(inputDate: String) -> String {

         let oldDateFormatter = DateFormatter()
         oldDateFormatter.dateFormat = "yyyy-MM-dd"

         let oldDate = oldDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMMM dd yyyy"

         return convertDateFormatter.string(from: oldDate!)
    }
}

extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

