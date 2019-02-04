
import Foundation

struct APIGeneralResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension APIGeneralResponse: LocalizedError {
    var errorDescription: String? {
        print("xxxxxxxx" , statusMessage)
        return statusMessage
    }
}
