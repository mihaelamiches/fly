
import Foundation

extension Date {
    
    init?(_ iso8601: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date = dateFormatter.date(from: iso8601) else { return nil }
        self = date
    }
    
    init?(medium: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        guard let date = dateFormatter.date(from: medium) else { return nil }
        self = date
    }
    
    init(short: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self = dateFormatter.date(from: short) ?? Date.now
    }
    
    static var now: Date {
        return Date()
    }
    
   var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var queryString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    var mediumString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd MMM HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    var shortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd MMM"
        
        return dateFormatter.string(from: self)
    }
    
    var weekDay: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }
}
