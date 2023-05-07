import Foundation
import Alamofire

class API {
    static let shared = API()
    
    private init() {}
    
    // CREATE
    func createBread(_ bread: Bread, completion: @escaping (Result<Bread, Error>) -> Void) {
        let url = URL(string: "http://192.168.0.101:3003/api/breads")!

        let parameters: [String: Any] = [
            "name": bread.name,
            "hasGluten": bread.hasGluten,
            "image": bread.image,
            "baker": bread.baker
        ]

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Bread.self) { response in
            switch response.result {
            case .success(let createdBread):
                completion(.success(createdBread))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // READ - LIST
    func fetchBreads(completion: @escaping (Result<[Bread], AFError>) -> Void) {
        let url = "http://192.168.0.101:3003/api/breads"
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Bread].self) { response in
            completion(response.result)
        }
    }
    
    // UPDATE
    func updateBread(_ bread: Bread, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://192.168.0.101:3003/api/breads/\(bread.id)"
        let parameters: [String: Any] = [
            "name": bread.name,
            "hasGluten": bread.hasGluten,
            "image": bread.image,
            "baker": bread.baker
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).validate().response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // DELETE
    func deleteBread(_ bread: Bread, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://192.168.0.101:3003/api/breads/\(bread.id)"
        
        AF.request(url, method: .delete).validate().response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
