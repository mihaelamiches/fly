
struct Airport {
    let code: String
    let name: String
}

extension Airport {
    init(_ code: String) {
        self.code = code
        self.name = code
    }
}

extension Airport: Hashable, Equatable {
    static func ==(lhs: Airport, rhs: Airport) -> Bool {
        return lhs.code == rhs.code
    }
    
    var hashValue: Int {
        return code.hashValue
    }
}
