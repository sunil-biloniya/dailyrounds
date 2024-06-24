//
//  BookMarkViewModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import Foundation


struct Pagination {
    var current : Int = 1
    var pageSize: Int = 10
    var search: String = ""
}


class BookMarkViewModel {
    
    /// variables
    var books: [BookmarkDoc] = []
    var savedBookMark: [BookmarkEntity] = []
    var currentSortingOption: SortingOption = .none
    var pagination: Pagination = Pagination()
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var typingTimer: Timer?
    
    /// static messages
    private let msg = "Something went wrong!"
    private let internetConnection = "Internet connection appears offline."

    
    /// get books api request
    func fetchBooks() {
        if Reachability.isConnectedToNetwork() {
            var urlString = "https://openlibrary.org/search.json?limit=\(pagination.pageSize)&offset=\(pagination.current)"
            if pagination.search.isEmpty == false {
                urlString = "https://openlibrary.org/search.json?title=\(pagination.search)&limit=\(pagination.pageSize)&offset=\(pagination.current)"
            }
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self.onError?(self.msg)
                }
                return
            }
            
            debugPrint(url)
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.onError?(error.localizedDescription)
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.onError?(self.msg)
                    }
                    return
                }
                // Print the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                
                do {
                    let response = try JSONDecoder().decode(BookmarkModel.self, from: data)
                    DispatchQueue.main.async {
                        if let book = response.docs {
                            if self.pagination.current == 1 {
                                self.books = book
                            } else {
                                self.books.append(contentsOf: book)
                            }
                            debugPrint(self.books.count)
                            self.pagination.current = response.offset ?? 0
                        }
                        
                        if self.currentSortingOption != .none {
                            self.sortBooks(by: self.currentSortingOption)
                        }
                        self.onUpdate?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onError?(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async {
                self.onError?(self.internetConnection)
            }
        }
    }
    /// get saved books
    func getBookMarked() {
        guard let userID = UserDefaults.standard.value(forKey: "users") as? String else {return}
        savedBookMark = CoreDataManager.shared.fetchBook(forUserId: userID)
    }
    
    /// apply sort  by button click
    func sortBooks(by option: SortingOption) {
        self.currentSortingOption = option
        switch option {
        case .title:
            books.sort { $0.title ?? "" < $1.title ?? "" }
        case .averageRating:
            books.sort { $0.ratingsAverage ?? 0 > $1.ratingsAverage ?? 0 }
        case .hits:
            books.sort { $0.ratingsCount ?? 0 > $1.ratingsCount ?? 0 }
        case .none:
            break
        }
    }
}
