
import Foundation

class Deletes : API {
    
    //taskForDeleteRequest
    
    
    
    //taskForDeleteRequest
    //LogoutRequest
    //let body = LogoutRequest(sessionId: Auth.sessionId)
    //Endpoints.logout.url
    //    class func logout(completion: @escaping () -> Void) {

    
    
       class func logout(completion: @escaping () -> Void) {

        //Declare Body Of Post
        let body = LogoutRequest(sessionId: Auth.sessionId)
        taskForDeleteRequest(url: Endpoints.logout.url, responseModel: APIGeneralResponse.self, body: body) { response, error in
            if error != nil  {
                print("Deleted")
                Auth.requestToken = ""
                Auth.sessionId = ""
                completion()
            } else {
                print("error1")
                completion()
            }
        }
    }
    
//    class func logout(completion: @escaping () -> Void) {
//        var request = URLRequest(url: Endpoints.logout.url)
//        request.httpMethod = "DELETE"
//        let body = LogoutRequest(sessionId: Auth.sessionId)
//        request.httpBody = try! JSONEncoder().encode(body)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            print("....",data)
//
//            Auth.requestToken = ""
//            Auth.sessionId = ""
//            completion()
//        }
//        task.resume()
//    }
    
    


    
}

