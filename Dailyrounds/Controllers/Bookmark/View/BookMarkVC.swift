//
//  BookMarkVC.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import UIKit
enum SortingOption {
    case title
    case averageRating
    case hits
    case none
}

class BookMarkVC: UIViewController {
    static func storyboardInstance() -> BookMarkVC {
        return BookMarkVC(nibName: String.className(self), bundle: nil)
    }
    /// outlets
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet var btnSort: [UIButton]!
    
    

    
    lazy var viewModel: BookMarkViewModel = BookMarkViewModel()
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
        self.startLoading(sender: self.view)
        self.viewModel.fetchBooks()
        

        // Do any additional setup after loading the view.
    }
    
    /// viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getBookMarked()
    }
    /// tableview and search bar set up
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BookmarkTableCell", bundle: nil), forCellReuseIdentifier: "BookmarkTableCell")
        textSearch.clearButtonMode = .whileEditing
        textSearch.delegate = self
        textSearch.addDoneButtonOnKeyboard()
        if let systemImage = UIImage(systemName: "magnifyingglass") {
            textSearch.setLeftImage(systemImage)
        }
        
    }
    
    /// viewModel events
    private func setupViewModel() {
        /// on success
        viewModel.onUpdate = { [weak self] in
            if let self = self {
                self.tableView.reloadData()
                self.tableView.stopLoading()
                self.stopLoading(sender: self.view)
                btnStack.isHidden = viewModel.books.count == 0
            }
        }
        /// getting errors
        viewModel.onError = { error in
            self.stopLoading(sender: self.view)
            // Handle error appropriately (e.g., show an alert)
            debugPrint("Error fetching books: \(error)")
            self.showAlert(with: error)
        }
    }
    /// click on saved book mark
    @IBAction func didTapBookMark(_ sender : UIButton) {
        self.push(SavedBookMarkedVC.storyboardInstance())
    }
    
    /// click on saved logout
    @IBAction func didTapLogout(_ sender : UIButton) {
        self.showAlertLogOut(withMessage: "Are you sure you want to logout?") { action in
            UserDefaults.standard.removeObject(forKey: "users")
            RootView.shared.setRoot(IntroductionVC.storyboardInstance())
        }
        self.push(SavedBookMarkedVC.storyboardInstance())
    }
    
    /// click on filter button actions
    @IBAction func didTapSort(_ sender : UIButton) {
        switch sender.tag {
        case 101:
            btnSort.forEach { $0.backgroundColor = $0.tag == sender.tag ? UIColor.lightGray : UIColor.clear}
            viewModel.sortBooks(by: .title)
            break
        case 102:
            btnSort.forEach { $0.backgroundColor = $0.tag == sender.tag ? UIColor.lightGray : UIColor.clear}
            viewModel.sortBooks(by: .averageRating)
            break
            
        case 103:
            btnSort.forEach { $0.backgroundColor = $0.tag == sender.tag ? UIColor.lightGray : UIColor.clear}
            viewModel.sortBooks(by: .hits)
            break
        default:
            break
        }
        tableView.reloadData()
    }
}
// MARK: - UITextFieldDelegate
extension BookMarkVC: UITextFieldDelegate{
    /// mathod called when you search
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text,text.count > 2  else {return}
        viewModel.pagination.search = text
        viewModel.pagination.current = 1
        self.startLoading(sender: self.view)
        self.viewModel.fetchBooks()
    }
    /// mathod called when you click on cross button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.pagination.search = ""
        viewModel.pagination.current = 1
        self.startLoading(sender: self.view)
        self.viewModel.fetchBooks()
        return true
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BookMarkVC: UITableViewDataSource & UITableViewDelegate {
    /// number of cells the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setMessage(message: viewModel.books.count == 0 ? "Data not found" : nil)
        return viewModel.books.count
    }
    /// display the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableCell", for: indexPath) as! BookmarkTableCell
        cell.details = viewModel.books[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// Load more when reaching the last cell
        if indexPath.row == viewModel.books.count - 1 {
            tableView.addLoadingSection {
                self.viewModel.pagination.current += 1
                self.viewModel.fetchBooks()
            }
        }
    }
    
    /// swipe trailing actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let match = self.viewModel.savedBookMark.first(where: {($0.title == self.viewModel.books[indexPath.row].title)})
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, handler) in
            if let match = match {
                CoreDataManager.shared.deleteBookMark(book: match)
                self.viewModel.getBookMarked()
                self.viewModel.books[indexPath.row].isSelect = false
            } else {
                let _ = CoreDataManager.shared.saveBookmark(self.viewModel.books[indexPath.row])
                self.viewModel.getBookMarked()
                self.viewModel.books[indexPath.row].isSelect = true
            }
            handler(true)
        }
        if let _ = match {
            self.viewModel.books[indexPath.row].isSelect = true
        } else {
            self.viewModel.books[indexPath.row].isSelect = false
        }
        
        deleteAction.image = UIImage(named: self.viewModel.books[indexPath.row].isSelect ? "ic_saved_bookmark" : "ic_green_bookmark")
        
        deleteAction.backgroundColor = .systemGray6
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
