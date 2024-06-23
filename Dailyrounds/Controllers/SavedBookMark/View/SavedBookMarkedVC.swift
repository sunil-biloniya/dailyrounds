//
//  SavedBookMarkedVC.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 22/06/24.
//

import UIKit

class SavedBookMarkedVC: UIViewController {
    static func storyboardInstance() -> SavedBookMarkedVC {
        return SavedBookMarkedVC(nibName: String.className(self), bundle: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: SavedBookMarkedViewModel = SavedBookMarkedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
        self.viewModel.getBookMarked()
        // Do any additional setup after loading the view.
    }

    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BookmarkTableCell", bundle: nil), forCellReuseIdentifier: "BookmarkTableCell")
    }
    
    private func setupViewModel() {
        viewModel.onUpdate = { [weak self] in
            if let self = self {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
}

extension SavedBookMarkedVC: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setMessage(message: viewModel.books.count == 0 ? "Data not found" : nil)
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableCell", for: indexPath) as! BookmarkTableCell
        cell.savedDetails = viewModel.books[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, handler) in
            CoreDataManager.shared.deleteBookMark(book: self.viewModel.books[indexPath.row])
            self.viewModel.getBookMarked()
            tableView.reloadData()
            handler(true)
        }
      
        deleteAction.image = UIImage(named: "ic_saved_bookmark")
        
        deleteAction.backgroundColor = .systemGray6
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
