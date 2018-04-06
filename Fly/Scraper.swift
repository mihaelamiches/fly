import Foundation

struct Scraper {
    
    static func scrape(resource: Resource, callback: @escaping (([Labels]) -> Void)) {
        let dispatchGroup = DispatchGroup()
        var allResults: [Labels] = []

        resource.requests.forEach { url in
            dispatchGroup.enter()
            scrape(url, callback: { results in
                allResults.append(results)
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { callback(allResults) }
    }
    
    static func scrape(_ url: URL, callback: @escaping LabelsCallback) {
        let urlSession = URLSession(configuration: .default)
       // print(url.absoluteString)
        urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else  { print(ApplicationError.rogue(error)); return callback([:]) }
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                let raw = json as? Labels
                else { print(ApplicationError.invalidResponse(response)); return callback([:]) }
            callback(["url": url, "results": raw])
        }).resume()
    }
}
