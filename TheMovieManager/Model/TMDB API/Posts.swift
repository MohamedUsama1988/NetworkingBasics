
import Foundation

class Posts : API {
    
    
    //No need to get all object >> just success or not in bool form & and store result in global variable
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        //Declare Body Of Post
        let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
       
        
        taskForPOSTRequest(url: Endpoints.login.url, responseModel: RequestTokenResponse.self, body: body) { response, error in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    //No need to get all object >> just success or not in bool form & and store result in global variable
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
       
        //Declare Body Of Post
        let body = PostSession(requestToken: Auth.requestToken)
        
        
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseModel: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.sessionId
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    
    //No need to get all object >> just success or not in bool form & and store result in global variable
    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
       
        //Declare Body Of Post
        let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
       
        
        taskForPOSTRequest(url: Endpoints.markWatchlist.url, responseModel: APIGeneralResponse.self, body: body) { response, error in
            if let response = response {
                // separate codes are used for posting, deleting, and updating a response
                // all are considered "successful"
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    
    //No need to get all object >> just success or not in bool form & and store result in global variable
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        
        //Declare Body Of Post
        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
        
        
        taskForPOSTRequest(url: Endpoints.markFavorite.url, responseModel: APIGeneralResponse.self, body: body) { response, error in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}
