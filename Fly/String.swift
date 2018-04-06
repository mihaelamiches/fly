extension String {
    var length: Int {
        return self.characters.count
    }
    
    var degrees: Double {
        let direction = self[index(endIndex, offsetBy: -1)..<endIndex]
        
        guard ["S", "W", "N", "E"].contains(direction) else { print("!!!", self, direction); return 0 }
        
        let sign = direction == "S" || direction == "W" ? -1.0 : 1.0
        
        var start = startIndex
        let degrees = self[start..<index(start, offsetBy: 3)]
        
        var deg = 0.0
        var m = ""
        
        
        if degrees != "000" {
            if degrees[start..<index(start, offsetBy: 1)] == "0" {
                deg = Double(String(self[start..<index(start, offsetBy: 3)])) ?? 0
                start = index(start, offsetBy: 3)
            } else {
                deg = Double(String(self[start..<index(start, offsetBy: 2)])) ?? 0
                start = index(start, offsetBy: 2)
            }
            m = String(self[start..<index(start, offsetBy: 2)])
            start = index(start, offsetBy: 2)
        } else {
            start = index(start, offsetBy: 3)
            m = String(self[start..<index(start, offsetBy: 1)])
            start = index(start, offsetBy: 1)
        }
        
        
        let dm = self[start..<index(endIndex, offsetBy: -1)]
        
        let mmm = Double("\(m).\(dm)") ?? 0
        
        return sign*(deg + mmm/60.0)
    }
}
