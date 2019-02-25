//
//  GitHubAPIImp.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/24/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

final class GitHubAPIImp: GitHubAPI {
    
    private var dataTask: URLSessionDataTask?
    
    func getRepositories(createdIn period: GitHubPeriod, sortBy sort: GitHubSortType, orderBy order: GitHubSortOrder, completion: @escaping GitHubGetRepositoryResult) {
        
        dataTask?.cancel()
        
        //TODO: refactor & extract request logic to NetworkRequestor
        
        let baseURL = "https://api.github.com/"
        let searchRepositories = "search/repositories"
        
        let rawQuery = "q=\(period.queryParam)&sort=\(sort.queryParam)&order=\(order.queryParam)"
        let customCharSet = CharacterSet(charactersIn: "><:")
        let allowedCharSet = customCharSet.union(.urlQueryAllowed)
        
        if var urlComponents = URLComponents(string: baseURL + searchRepositories),
            let query = rawQuery.addingPercentEncoding(withAllowedCharacters: allowedCharSet) {
            urlComponents.query = query
            if let url = urlComponents.url {
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("API call error: \(error.localizedDescription)")
                        completion(Result.failure(error))
                    } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == HTTPStatusCode.OK.rawValue {
                        
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let decoded = try decoder.decode(GitHubGetRepositoriesResponse.self, from: data)
                            completion(Result.success(decoded.items))
                        } catch let error {
                            print("API call response decode error: \(error.localizedDescription)")
                            completion(Result.failure(error))
                        }
                    }
                    
                    self.dataTask = nil
                }
                
                dataTask?.resume()
            }
        }
    }
    
}

private extension GitHubPeriod {
    
    // https://help.github.com/en/articles/searching-for-repositories#search-by-when-a-repository-was-created-or-last-updated
    
    var queryParam: String {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        
        switch self {
        case .lastMonth:
            let firstDayOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let dateString = DateFormatter.periodQuery.string(from: firstDayOfCurrentMonth)
            return "created:>=\(dateString)"
            
        case .lastWeek:
            let firstDayOfCurrentWeek = calendar.date(from: calendar.dateComponents([.year, .month, .weekOfMonth], from: now))!
            let dateString = DateFormatter.periodQuery.string(from: firstDayOfCurrentWeek)
            return "created:>=\(dateString)"
            
        case .lastDay:
            let today = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: now))!
            let dateString = DateFormatter.periodQuery.string(from: today)
            return "created:>=\(dateString)"
        }
    }
}

private extension GitHubSortType {
    
    var queryParam: String {
        switch self {
        case .stars:
            return "stars"
        }
    }
    
}

private extension GitHubSortOrder {
    
    var queryParam: String {
        switch self {
        case .descending:
            return "desc"
        case .ascending:
            return "asc"
        }
    }
    
}

private extension DateFormatter {
    
    static let periodQuery: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
}
