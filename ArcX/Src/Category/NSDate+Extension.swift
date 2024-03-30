//
// Created by MAC on 2023/11/30.
//

import Foundation

extension Date {

    enum Formatter: String {
        case dateTime = "yyyy-MM-dd HH:mm:ss"
        case dateTimeWithoutSeconds = "yyyy-MM-dd HH:mm"
        case date = "yyyy-MM-dd"
        case time = "HH:mm:ss"
    }

    func formatted(_ formatter: Formatter, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String {
        formatted(formatter.rawValue, timeZone: timeZone, locale: locale)
    }

    func formatted(_ formatter: String, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = formatter
        dateFmt.timeZone = timeZone
        dateFmt.locale = locale
        dateFmt.calendar = Calendar(identifier: .gregorian)
        return dateFmt.string(from: self)
    }
}