import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL

let host = "edeholland.nl"
let user = "u31866p26799_s4d"
let password = "s4dpassword"
let database = "u31866p26799_backend"

var routes = Routes()

class Businesses {
    
    var data = [[String:String]]()
    
    init() {
        var ary = [[String:String]]()
        let mysql = MySQL()
        let connected = mysql.connect(host: host, user: user, password: password, db: database)
        
        guard connected else {
            print(mysql.errorMessage())
            return
        }
        defer {
            mysql.close()                           //Always executed
        }
        let querySuccess = mysql.query(statement: "SELECT id, name, location FROM businesses")
        guard querySuccess else {
            return
        }
        
        let results = mysql.storeResults()!         // Save the results
        
        results.forEachRow { row in
            let id = row[0]!
            let name = row[1]!
            let location = row[2]!
            let dict = ["id":"\(id)", "name":"\(name)", "location":"\(location)"]
            ary.append(dict)
        }
        
        data = ary
    }
    
    public func listArray() -> Array<Any> {
        return self.data
    }
    
    public func listJSON() -> String {
        return convertToJSON()
    }
    
    private func convertToJSON() -> String {
        return "Hier komt code om van de array met dictionaries een JSON-string te maken"
    }
    
}

let businesses = Businesses.init()

print(businesses.listArray())
print(businesses.listJSON())

routes.add(method: .get, uri: "/") {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Placeholder title</title><body>Placeholder body</body></html>")
        .completed()
}

routes.add(method: .get, uri: "/api") {
    request, response in
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: businesses.listJSON())
        .completed()
}

do {
    // Launch the HTTP server.
    try HTTPServer.launch(
        .server(name: "www.example.ca", port: 8181, routes: routes))
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}

