
struct Country {
    let code: String
    let name: String
    let group: String
    
    init?(_ labelled : Labels) {
        guard let code = labelled["countryCode"] as? String,
            let name = labelled["countryName"] as? String,
            let group = labelled["countryGroupName"] as? String
            else { return nil }
        
        self.code = code
        self.name = name
        self.group = group
    }
}
