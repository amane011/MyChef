//
//  SearchIngredientsViewController.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/17/24.
//

import UIKit

class SearchIngredientsViewController: UIViewController {
    var ingredients : [String] = []
    var filteredIngredients: [String] = []
    var addedIngredients: [String] = []
    var isFiltering: Bool = false
    var ingredientsCollectionView: UICollectionView!
    weak var delegate: SearchIngredientsViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = Array(IngredientsDataManager.shared.ingredientsSet)
        view.backgroundColor = .black
        configureIngredientsCollectionView()
        configureSearchController()
        navigationController?.navigationBar.tintColor  = .appCream
        UITabBar.appearance().tintColor = .appCream
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil { // The view controller is being popped
            delegate?.didAddIngredients(addedIngredients)
        }
    }

    
    private func configureIngredientsCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 2
        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ingredientsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsCollectionView.backgroundColor = .clear // Use clear color for collectionView
        ingredientsCollectionView.register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: "IngredientsCollectionViewCell")
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        view.addSubview(ingredientsCollectionView)
        
        NSLayoutConstraint.activate([
            ingredientsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingredientsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ])
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search ingredients"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func showMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .appCream
        messageLabel.backgroundColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.layer.cornerRadius = 8
        messageLabel.layer.masksToBounds = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.alpha = 0  // start out invisible
        
        view.addSubview(messageLabel)

        // Constraints
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            messageLabel.heightAnchor.constraint(equalToConstant: 50),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])

        // Animate the message label
        UIView.animate(withDuration: 0.5, animations: {
            messageLabel.alpha = 1  // fade in
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: {
                messageLabel.alpha = 0  // fade out
            }) { _ in
                messageLabel.removeFromSuperview()  // remove after fading out
            }
        }
    }

}

extension SearchIngredientsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredIngredients.count : ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCollectionViewCell", for: indexPath) as! IngredientsCollectionViewCell
        let ingredient = isFiltering ? filteredIngredients[indexPath.row] : ingredients[indexPath.row]
        cell.ingredientLabel.text = ingredient
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let label = UILabel(frame: .zero)
        let ingredient = isFiltering ? filteredIngredients[indexPath.row] : ingredients[indexPath.row]
        label.text = ingredient
        label.sizeToFit()
        let size = label.frame.size
        let width = max(size.width + padding, 80)
        let height = max(size.height + padding, 20)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredient = isFiltering ? filteredIngredients[indexPath.row] : ingredients[indexPath.row]
        addedIngredients.append(ingredient)
        if isFiltering {
            filteredIngredients.remove(at: indexPath.row)
        } else {
            ingredients.remove(at: indexPath.row)
        }
        ingredientsCollectionView.reloadData()
        self.showMessage("\(ingredient) was added")
        
    }
}

extension SearchIngredientsViewController:  UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isFiltering = false
            filteredIngredients.removeAll()
            ingredientsCollectionView.reloadData()
            return
        }

        isFiltering = true
        filteredIngredients = ingredients.filter { $0.lowercased().contains(searchText.lowercased()) }
        ingredientsCollectionView.reloadData()
    }
    
        
}
