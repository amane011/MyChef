//
//  AllFilterViewController.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/12/24.
//

import UIKit

protocol SearchIngredientsViewControllerDelegate: AnyObject {
    func didAddIngredients(_ ingredients: [String])
}

class AllFilterViewController: UIViewController{
    
    
    
    var ingredients : [String] = []
    var ingredientsCollectionView: UICollectionView!
    let ingredientsContainerView = UIView()
    let ingredientsHeaderLabel = UILabel()
    let addMoreImage = UIImageView()
    let addMoreTextLabel = UILabel()
    
    let caloriesContainerView = UIView()
    let caloriesHeaderLabel = UILabel()
    let under500Button = RadioButton()
    let from500To1000Button = RadioButton()
    let from1000To1500Button = RadioButton()
    var selectedCalorieRange: String?
    
    let dietaryPreferences = ["Vegan", "Paleo", "Keto", "Dairy-Free", "Vegetarian", "Gluten-Free"]
    var selectedPreferences: Set<String> = []
    let dietPrefContainerView = UIView()
    let dietPrefHeaderLabel = UILabel()
    var dietPrefCollectionView: UICollectionView!
        
    let createReciepeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appCream
        print(ingredients)
        setupIngredientsCard()
        setupCalories()
        setupDietPref()
        setupCreateReciepeButton()
    }
    
    private func setupIngredientsCard(){
        configureContainerView()
        configureHeaderLabel()
        configureCollectionView()
        configureAddMore()
    }
    
    private func setupCalories() {
        configureCaloriesContainerView()
        configureCaloriesHeaderLabel()
        configureRadioButtons()
    }
    
    private func setupDietPref(){
        configureDietPrefContainerView()
        configureDietPrefHeaderLabel()
        configureDietPrefCollectionView()
    }
    
    private func configureContainerView() {
        ingredientsContainerView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsContainerView.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.2)
        ingredientsContainerView.layer.borderWidth = 4
        ingredientsContainerView.layer.borderColor = UIColor.brown.cgColor
        ingredientsContainerView.layer.cornerRadius = 10
        ingredientsContainerView.layer.masksToBounds = true
        view.addSubview(ingredientsContainerView)

        NSLayoutConstraint.activate([
            ingredientsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ingredientsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ingredientsContainerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureHeaderLabel() {
        ingredientsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsHeaderLabel.text = "Ingredients"
        ingredientsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        ingredientsHeaderLabel.textColor = .black
        ingredientsHeaderLabel.textAlignment = .left
        ingredientsHeaderLabel.layer.cornerRadius = 6
        ingredientsHeaderLabel.layer.masksToBounds = true
        ingredientsHeaderLabel.backgroundColor = .appCream
        ingredientsHeaderLabel.textAlignment = .center
        ingredientsHeaderLabel.layer.borderWidth = 2
        ingredientsHeaderLabel.layer.borderColor = UIColor.black.cgColor
        ingredientsContainerView.addSubview(ingredientsHeaderLabel)

        NSLayoutConstraint.activate([
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: ingredientsContainerView.topAnchor, constant: 10),
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: ingredientsContainerView.leadingAnchor, constant: 8),
            ingredientsHeaderLabel.heightAnchor.constraint(equalToConstant: 25),
            ingredientsHeaderLabel.widthAnchor.constraint(equalToConstant: 120)// Adjust the height as needed
        ])
    }
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 4
        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ingredientsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsCollectionView.backgroundColor = .clear // Use clear color for collectionView
        ingredientsCollectionView.register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: "IngredientsCollectionViewCell")
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        ingredientsContainerView.addSubview(ingredientsCollectionView)
        
        NSLayoutConstraint.activate([
            ingredientsCollectionView.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 10),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: ingredientsContainerView.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: ingredientsContainerView.trailingAnchor),
            ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])

    }
    

    
    private func configureAddMore() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addMoreClicked))
        addMoreImage.image = UIImage(systemName: "plus.circle")
        addMoreImage.translatesAutoresizingMaskIntoConstraints = false
        addMoreImage.tintColor = .black
        addMoreImage.isUserInteractionEnabled = true
        addMoreImage.isUserInteractionEnabled = true
        addMoreImage.addGestureRecognizer(tapGesture)
        ingredientsContainerView.addSubview(addMoreImage)
        
        NSLayoutConstraint.activate([
            addMoreImage.leadingAnchor.constraint(equalTo: ingredientsContainerView.leadingAnchor, constant: 5),
            addMoreImage.bottomAnchor.constraint(equalTo: ingredientsContainerView.bottomAnchor, constant: -5),
            addMoreImage.heightAnchor.constraint(equalToConstant: 21),
            addMoreImage.widthAnchor.constraint(equalToConstant: 21)
        ])
        
        addMoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addMoreTextLabel.text = "Click to add more ingredients"
        addMoreTextLabel.font = UIFont.boldSystemFont(ofSize: 13)
        addMoreTextLabel.textAlignment = .left
        addMoreTextLabel.textColor = .black
        addMoreTextLabel.isUserInteractionEnabled = true
        addMoreTextLabel.addGestureRecognizer(tapGesture)
        ingredientsContainerView.addSubview(addMoreTextLabel)
        NSLayoutConstraint.activate([
            addMoreTextLabel.leadingAnchor.constraint(equalTo: addMoreImage.trailingAnchor, constant: 5),
            addMoreTextLabel.bottomAnchor.constraint(equalTo: ingredientsContainerView.bottomAnchor, constant: -5),
            addMoreTextLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
       
    }
    
    @objc func addMoreClicked() {
        let searchIngredientsVC = SearchIngredientsViewController()
//        present(searchIngredientsVC, animated: true)
        searchIngredientsVC.delegate = self
        self.navigationController?.pushViewController(searchIngredientsVC, animated: false)
    }
    
    
    private func configureCaloriesContainerView() {
        caloriesContainerView.translatesAutoresizingMaskIntoConstraints = false
        caloriesContainerView.backgroundColor = .black
        caloriesContainerView.layer.cornerRadius = 10
        caloriesContainerView.layer.masksToBounds = true
        view.addSubview(caloriesContainerView)

        NSLayoutConstraint.activate([
            caloriesContainerView.topAnchor.constraint(equalTo: ingredientsContainerView.bottomAnchor, constant: 10),
            caloriesContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            caloriesContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            caloriesContainerView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureCaloriesHeaderLabel() {
        caloriesHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesHeaderLabel.text = "Calories"
        caloriesHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        caloriesHeaderLabel.textColor = .black
        caloriesHeaderLabel.backgroundColor = .appCream
        caloriesHeaderLabel.layer.cornerRadius = 6
        caloriesHeaderLabel.layer.masksToBounds = true
        caloriesHeaderLabel.textAlignment = .center
        caloriesContainerView.addSubview(caloriesHeaderLabel)

        NSLayoutConstraint.activate([
            caloriesHeaderLabel.topAnchor.constraint(equalTo: caloriesContainerView.topAnchor, constant: 10),
            caloriesHeaderLabel.leadingAnchor.constraint(equalTo: caloriesContainerView.leadingAnchor, constant: 8),
            caloriesHeaderLabel.widthAnchor.constraint(equalToConstant: 90),
            caloriesHeaderLabel.heightAnchor.constraint(equalToConstant: 25) // Adjust the height as needed
        ])
    }
    
    private func configureRadioButtons(){
        // Configure radio buttons
        configureRadioButton(under500Button, title: "Under 500", tag: 1)
        configureRadioButton(from500To1000Button, title: "500-1000", tag: 2)
        configureRadioButton(from1000To1500Button, title: "1000-1500", tag: 3)
        
        // Layout buttons (you'll want to replace this with your actual layout code)
        let stackView = UIStackView(arrangedSubviews: [under500Button, from500To1000Button, from1000To1500Button])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        caloriesContainerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: caloriesHeaderLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: caloriesContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: caloriesContainerView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func configureRadioButton(_ button: RadioButton, title: String, tag: Int) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.appCream, for: .normal)
        button.tintColor = .appCream
       
        button.tag = tag
        button.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ sender: RadioButton) {
        for button in [under500Button, from500To1000Button, from1000To1500Button] {
            button.isSelected = false
        }
        sender.isSelected = true
        switch sender.tag {
        case 1:
            selectedCalorieRange = "0-500"
        case 2:
            selectedCalorieRange = "500-1000"
        case 3:
            selectedCalorieRange = "1000-1500"
        default:
            selectedCalorieRange = nil
        }
        
        print("Selected Calorie Range: \(selectedCalorieRange ?? "None")")
    }
    
    private func configureDietPrefContainerView() {
        dietPrefContainerView.translatesAutoresizingMaskIntoConstraints = false
        dietPrefContainerView.backgroundColor = .black
        dietPrefContainerView.layer.cornerRadius = 10
        dietPrefContainerView.layer.masksToBounds = true
        view.addSubview(dietPrefContainerView)

        NSLayoutConstraint.activate([
            dietPrefContainerView.topAnchor.constraint(equalTo: caloriesContainerView.bottomAnchor, constant: 10),
            dietPrefContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dietPrefContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dietPrefContainerView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureDietPrefHeaderLabel() {
        dietPrefHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        dietPrefHeaderLabel.text = "Dietary Preferences"
        dietPrefHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dietPrefHeaderLabel.textColor = .black
        dietPrefHeaderLabel.textAlignment = .center
        dietPrefHeaderLabel.layer.cornerRadius = 6
        dietPrefHeaderLabel.layer.masksToBounds = true
        dietPrefHeaderLabel.backgroundColor = .appCream
        dietPrefContainerView.addSubview(dietPrefHeaderLabel)

        NSLayoutConstraint.activate([
            dietPrefHeaderLabel.topAnchor.constraint(equalTo: dietPrefContainerView.topAnchor, constant: 10),
            dietPrefHeaderLabel.leadingAnchor.constraint(equalTo: dietPrefContainerView.leadingAnchor, constant: 8),
            dietPrefHeaderLabel.widthAnchor.constraint(equalToConstant: 190),
            dietPrefHeaderLabel.heightAnchor.constraint(equalToConstant: 25) // Adjust the height as needed
        ])
    }
    
    private func configureDietPrefCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // This will allow dynamic width
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        dietPrefCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dietPrefCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dietPrefCollectionView.delegate = self
        dietPrefCollectionView.dataSource = self
        dietPrefCollectionView.register(DietaryPreferenceCell.self, forCellWithReuseIdentifier: "DietaryPreferenceCell")
        dietPrefCollectionView.backgroundColor = .clear
        dietPrefContainerView.addSubview(dietPrefCollectionView)
        
        NSLayoutConstraint.activate([
            dietPrefCollectionView.topAnchor.constraint(equalTo: dietPrefHeaderLabel.bottomAnchor, constant: 10),
            dietPrefCollectionView.leadingAnchor.constraint(equalTo: dietPrefContainerView.leadingAnchor),
            dietPrefCollectionView.trailingAnchor.constraint(equalTo: dietPrefContainerView.trailingAnchor, constant: -5),
            dietPrefCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCreateReciepeButton() {
        createReciepeButton.translatesAutoresizingMaskIntoConstraints = false
        createReciepeButton.backgroundColor = .black
        createReciepeButton.setTitle("Create Reciepe", for: .normal)
        createReciepeButton.setTitleColor(.appCream, for: .normal)
        createReciepeButton.layer.cornerRadius = 16
        createReciepeButton.addTarget(self, action: #selector(createRecipe), for: .touchUpInside)
        
        view.addSubview(createReciepeButton)
        
        NSLayoutConstraint.activate([
            createReciepeButton.topAnchor.constraint(equalTo: dietPrefContainerView.bottomAnchor, constant: 40),
            createReciepeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createReciepeButton.heightAnchor.constraint(equalToConstant: 40),
            createReciepeButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc func createRecipe() {
        let recipeDetails = Recipe(ingredients: ingredients, selectedPreferences: selectedPreferences, selectedCalorieRange: selectedCalorieRange)
        let recipeVC = RecipeViewController()
        recipeVC.recipeDetails = recipeDetails
        navigationController?.pushViewController(recipeVC, animated: true)
    }
}



extension AllFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ingredientsCollectionView {
            return ingredients.count
        } else if collectionView == dietPrefCollectionView {
            return dietaryPreferences.count
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ingredientsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCollectionViewCell", for: indexPath) as! IngredientsCollectionViewCell
            let ingredient = Array(ingredients)[indexPath.row]
            cell.ingredientLabel.text = ingredient
            return cell
        } else if collectionView == dietPrefCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DietaryPreferenceCell", for: indexPath) as! DietaryPreferenceCell
            let preference = dietaryPreferences[indexPath.row]
            cell.configure(with: preference, isSelected: selectedPreferences.contains(preference))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dietPrefCollectionView {
            let preference = dietaryPreferences[indexPath.row]
            if selectedPreferences.contains(preference) {
                selectedPreferences.remove(preference)
            } else {
                selectedPreferences.insert(preference)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension AllFilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ingredientsCollectionView {
            let padding: CGFloat = 5 // You can adjust padding
            let label = UILabel(frame: .zero)
            label.text = Array(ingredients)[indexPath.row]
            label.sizeToFit()
            let size = label.frame.size
            let width = max(size.width + padding, 80) // Ensure minimum width and add padding
            let height = max(size.height + padding, 20) // Ensure minimum height and add padding
            return CGSize(width: width, height: height)
        } else if collectionView == dietPrefCollectionView {
            
            let padding: CGFloat = 5 // You can adjust padding
            let label = UILabel(frame: .zero)
            label.text = dietaryPreferences[indexPath.row]
            label.sizeToFit()
            let size = label.frame.size
            let width = max(size.width + padding, 80) // Ensure minimum width and add padding
            let height = max(size.height + padding, 20) // Ensure minimum height and add padding
            return CGSize(width: width, height: height)
        }
        
        return CGSize()
    }
}

extension AllFilterViewController:  SearchIngredientsViewControllerDelegate {
    func didAddIngredients(_ ingredients: [String]) {
        self.ingredients.append(contentsOf: ingredients)
        self.ingredientsCollectionView.reloadData()
    }
}
