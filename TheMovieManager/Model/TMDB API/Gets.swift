

import Foundation

class Gets : API {
    
    
    //No need to get all object >> just success or not in bool form & and store result in global variable
  class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
  _ = taskForGETRequest(url: Endpoints.getRequestToken.url, responseModle: RequestTokenResponse.self) { responseObject, error in
            if let responseObject = responseObject { Auth.requestToken = responseObject.requestToken ; completion(true, nil) }
            else { completion(false, error) }
        }
    }
    
    
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
    _ =  taskForGETRequest(url: Endpoints.getWatchlist.url, responseModle: MovieResults.self) { responseObject, error in
            if let responseObject = responseObject { completion(responseObject.results, nil)}
            else { completion([], error)}
        }
    }
    
    
    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
      _ =  taskForGETRequest(url: Endpoints.getFavorites.url, responseModle: MovieResults.self) { responseObject, error in
            if let responseObject = responseObject { completion(responseObject.results, nil)}
            else { completion([], error) }    // [] means array of nil objects == empty array
        }
    }
    
    
    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
         let task = taskForGETRequest(url: Endpoints.search(query).url, responseModle: MovieResults.self) { responseObject, error in
            if let responseObject = responseObject { completion(responseObject.results, nil) }
            else { completion([], error) }
        }
        return task
    }

}
