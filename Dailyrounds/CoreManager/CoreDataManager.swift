//
//  CoreDataManager.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func addUser(_ user: LoginSignUpModel)->Bool {
        let userEntity = UserEntity(context: context)
                userEntity.email = user.email
                userEntity.password = user.password
                userEntity.id = user.id
               return saveContext()
    }

    func updateUser(user: LoginSignUpModel, userEntity: UserEntity)->Bool {
        addUpdateUser(userEntity: userEntity, user: user)
    }

    private func addUpdateUser(userEntity: UserEntity, user: LoginSignUpModel)->Bool {
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.id = user.id
       return saveContext()
    }

    func fetchUsers() -> [UserEntity] {
        var users: [UserEntity] = []
        do {
            users = try context.fetch(UserEntity.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }
        return users
    }

    func saveBookmark(_ book: BookmarkDoc)->Bool {
        guard let userID = UserDefaults.standard.value(forKey: "users") as? String else {return false}
        
        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.authorName = book.authorName?.first ?? ""
        bookmarkEntity.ratingsAverage = book.ratingsAverage ?? 0.0
        bookmarkEntity.ratingsCount = Int64(book.ratingsCount ?? 0)
        bookmarkEntity.title = book.title
        bookmarkEntity.coverI = Int64(book.coverI ?? 0)
        bookmarkEntity.userId = userID
        bookmarkEntity.isSelect = book.isSelect
        return saveContext()
    }


    func fetchBook(forUserId userId: String) -> [BookmarkEntity] {
        var book: [BookmarkEntity] = []
        do {
            book = try context.fetch(BookmarkEntity.fetchRequest()).filter({$0.userId == userId})
        }catch {
            print("Fetch user error", error)
        }
       return book
    }
    
    func deleteBookMark(book: BookmarkEntity) {
        context.delete(book)
       let _ = saveContext()
    }
    
    private func saveContext() -> Bool {
        do {
            try context.save() // MIMP
            return true
        }catch {
            print("User saving error:", error)
            return false
        }
    }
}
