//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 28/09/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    private var categoryController : ListingViewController?
    private var categories : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategories()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonTapped() {
        categoryController = ListingViewController(canShowAddNewItemIfNotMatched: false, delegate: self)
        let navigationController = UINavigationController(rootViewController: categoryController!)
        categoryController?.contents = categories.compactMap { $0.title }
        categoryController?.navigationItem.title = "Choose category"
        present(navigationController, animated: true, completion: nil)
    }
    
    private func addExpense(category: Category) {
        let expenseController = AddExpenseViewController(cateogory: category)
        expenseController.navigationItem.title = "Add Expense"
        present(UINavigationController(rootViewController: expenseController) , animated: true, completion: nil)
    }
    
    private func setupCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        do {
            categories = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Found error while fetching categories")
        }
        
    }
}

extension HomeViewController : ListingViewControllerDelegate {
    func createNew(_ listItem: String) {
        categoryController?.dismiss(animated: true, completion: nil)
    }
    
    func selectedListItem(_ listItem : String) {
        if let cateogory = categories.first(where: { listItem == $0.title }) {
            categoryController?.dismiss(animated: true, completion: nil)
            addExpense(category: cateogory)
        }
    }
    
    
}
