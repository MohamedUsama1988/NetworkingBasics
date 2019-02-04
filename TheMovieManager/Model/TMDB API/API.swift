
import Foundation

class API {
    
    static let apiKey = "67724c1c418e3359232e9c363e42f3f3"
    
    struct Auth {
        static var accountId = 0               //It's optional parameter = 0
        static var requestToken = ""           //
        static var sessionId = ""              //
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(API.apiKey)"
        
        case getWatchlist
        case getFavorites
        case getRequestToken
        case login
        case createSessionId
        case logout
        case webAuth
        case search(String)
        case markWatchlist
        case markFavorite
        case posterImage(String)
        
        var UrlString : String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getFavorites:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/\(Auth.requestToken)?redirect_to=themoviemanager:authenticate"
            case .search(let query):
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            case .markWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .markFavorite:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .posterImage(let posterPath):
                return "https://image.tmdb.org/t/p/w500/" + posterPath
            }
        }
        
        var url: URL {
            return URL(string: UrlString)!
        }
    }
    
    
    //taskForGETRequest
    //ResponseModel   ====   <General Type : XXX >  path the model with extention Decodable
    //INs             ====   (URL  , responseModle.Type  )
    //OUTs            ====   (ResponseModel , error)
    //Steps >>
    //1- Try to unwrap data if failed >> completion with error + forced return
    //2- Try to Decode JSON to Swift object and return object using completion
    //3- if failed thats mean error response from server and also needs to be decoded to known the error
    //4- if failed thats meen other error
    
    //Other Form With "Where"
    //    class func taskForGETRequest<ResponseModel>(url: URL, responseModle: ResponseModel.Type, completion: @escaping (ResponseModel?, Error?) -> Void) -> URLSessionDataTask where ResponseModel : Decodable {
    //        ...
    //        ...
    //        ...
    //    }
    
    
    
    static func taskForGETRequest<ResponseModel: Decodable>     //general type
    (url: URL, responseModle: ResponseModel.Type, completion: @escaping (ResponseModel?, Error?) -> Void)  // Ins
        -> URLSessionDataTask       //Outs
    {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { DispatchQueue.main.async { completion(nil, error)} ; return}
            do { let responseObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                 DispatchQueue.main.async { completion(responseObject, nil) }}
            catch {
                    do { let errorResponse = try JSONDecoder().decode(APIGeneralResponse.self, from: data) as Error
                         DispatchQueue.main.async { completion(nil, errorResponse) }}
                    catch {
                    DispatchQueue.main.async { completion(nil, error)}
                           }
                   }
                                                         }
        task.resume()
        return task
    }
    
    
    
    static func taskForPOSTRequest<RequestModel: Encodable, ResponseModel: Decodable>
    (url: URL, responseModel: ResponseModel.Type, body: RequestModel, completion: @escaping (ResponseModel?, Error?) -> Void){
        
        //prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { DispatchQueue.main.async { completion(nil, error)} ; return}
            do { let responseObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                DispatchQueue.main.async { completion(responseObject, nil) }}
            catch {
                do { let errorResponse = try JSONDecoder().decode(APIGeneralResponse.self, from: data) as Error
                    DispatchQueue.main.async { completion(nil, errorResponse) }}
                catch {
                    DispatchQueue.main.async { completion(nil, error)}
                }
            }
        }
        task.resume()
    }
    
    
    
    
    static func taskForDeleteRequest<RequestModel: Encodable, ResponseModel: Decodable>
        (url: URL, responseModel: ResponseModel.Type, body: RequestModel, completion: @escaping (ResponseModel?, Error?) -> Void){
        
        //prepare request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { DispatchQueue.main.async { completion(nil, error)} ; return}
            do { let responseObject = try JSONDecoder().decode(ResponseModel.self, from: data)
                DispatchQueue.main.async { completion(responseObject, nil) }}
            catch {
                do { let errorResponse = try JSONDecoder().decode(APIGeneralResponse.self, from: data) as Error
                    DispatchQueue.main.async { completion(nil, errorResponse) }}
                catch {
                    DispatchQueue.main.async { completion(nil, error)}
                }
            }
        }
        task.resume()
    }
    
    
    
    static func logoutxx(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.requestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    
    
    static func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
}
