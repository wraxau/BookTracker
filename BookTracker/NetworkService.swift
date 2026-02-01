import Foundation
struct BookAPIResponce: Codable {
    let items: [Item]?
}

struct Item: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    
    enum CodingKeys: String, CodingKey {
        case title, authors, description, imageLinks = "imageLinks"
    }
    
}

struct ImageLinks: Codable {
    let thumbnail: String?
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func searchBooks(query: String, completion: @escaping (Result<[BookItem], Error >)-> Void ) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(escapedQuery)&maxResults=20"
        
      
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL) )
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(BookAPIResponce.self, from: data)
                let bookItems = apiResponse.items?.compactMap{  item -> BookItem? in
                    guard let title = item.volumeInfo.title else { return nil }
                    return BookItem (
                        id: item.id,
                        title: title,
                        author: item.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown",
                        description: item.volumeInfo.description ?? "No description", //
                        thumbnailURL: item.volumeInfo.imageLinks?.thumbnail
                    )
                } ?? []
                completion(.success(bookItems))
            } catch {
                completion(.failure(error))
            }
        } .resume()
        
    }
}

struct BookItem {
    let id: String
    let title: String
    let author: String
    let description: String
    let thumbnailURL: String?
}

enum NetworkError: Error {
    case noData
    case invalidData
    case invalidURL
    case decodingFailed
}
