import UIKit
import Combine
import SwiftUI

class NetworkClient {
    private let session = URLSession.shared
    
    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { (data, _, error) in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class NetworkSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
    private var subscriber: S?
    private let client: NetworkClient = .init()
    
    init(request: URLRequest, subscriber: S) {
        self.subscriber = subscriber
        sendRequest(request)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
    }
    
    private func sendRequest(_ request: URLRequest) {
        guard let subscriber = subscriber else { return }
        
        client.sendRequest(request) { result in
            switch result {
            case .success(let data):
                subscriber.receive(data)
            case .failure(let error):
                subscriber.receive(completion: .failure(error))
            }
        }
    }
}

struct NetworkPublisher: Publisher {
    typealias Output = Data
    typealias Failure = Error
    
    private let urlRequest: URLRequest
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    func receive<S: Subscriber>(subscriber: S) where
        NetworkPublisher.Failure == S.Failure,
        NetworkPublisher.Output == S.Input {
        let subscription = NetworkSubscription(
            request: urlRequest,
            subscriber: subscriber
        )
        subscriber.receive(subscription: subscription)
    }
}

private func buildUrlRequest() -> URLRequest {
    let url = URL(string: "https://dad-jokes.p.rapidapi.com/random/joke")!
    let headers: [String: String] = [
        "x-rapidapi-key": "892abfcd3cmsh3cca36ae3e40cb0p186360jsn7a6b411975ce",
        "x-rapidapi-host": "dad-jokes.p.rapidapi.com",
        "useQueryString": "true"
    ]
    var urlRequest = URLRequest(url: url)
    
    headers.forEach { field, value in
        urlRequest.addValue(value, forHTTPHeaderField: field)
    }
    
    return urlRequest
}


let a = NetworkPublisher(urlRequest: buildUrlRequest()).sink { completion in
    print(completion)
} receiveValue: { data in
    print(String(data: data, encoding: .utf8))
}

