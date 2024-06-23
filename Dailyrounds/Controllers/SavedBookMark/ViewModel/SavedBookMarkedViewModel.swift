//
//  SavedBookMarkedViewModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 22/06/24.
//

import Foundation
class SavedBookMarkedViewModel {
    /// variables
    var books: [BookmarkEntity] = []
    var onUpdate: (() -> Void)?
    
    /// get saved books
    func getBookMarked() {
        guard let userID = UserDefaults.standard.value(forKey: "users") as? String else {return}
        books = CoreDataManager.shared.fetchBook(forUserId: userID)
        onUpdate?()
    }
}
