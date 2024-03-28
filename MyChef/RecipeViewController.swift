import UIKit

class RecipeViewController: UIViewController {
    
    var recipeDetails: Recipe!
    var recipeTextView: UITextView!
    var ingredientsCollectionView: UICollectionView!
    var titleLabel: UILabel!
    var stepsLabel: UITextView!
    var recipe: ParsedRecipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateRecipe()
    }
    
    private func setupUI() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Initialize the UICollectionView for ingredients
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 4
        ingredientsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ingredientsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsCollectionView.backgroundColor = .clear // Use clear color for collectionView
        ingredientsCollectionView.register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: "IngredientsCollectionViewCell")
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.backgroundColor = .black
        ingredientsCollectionView.layer.cornerRadius = 6
        ingredientsCollectionView.layer.masksToBounds = true
        ingredientsCollectionView.isHidden = true
        view.addSubview(ingredientsCollectionView)
        
        // Initialize the UILabel for the steps and add it to the view
        stepsLabel = UITextView()
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.font = UIFont.systemFont(ofSize: 16)
        stepsLabel.textAlignment = .left
        stepsLabel.layer.cornerRadius = 10
        stepsLabel.backgroundColor = UIColor.appDarkBrown.withAlphaComponent(0.4)
        stepsLabel.layer.borderWidth = 4 // Set the border width
        stepsLabel.layer.borderColor = UIColor.brown.cgColor // Set the border color to brown
        stepsLabel.layer.masksToBounds = true // This is necessary to clip the content to the rounded corners
        stepsLabel.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.addSubview(stepsLabel)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            ingredientsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 100), // Fixed height for the collection view
            
            stepsLabel.topAnchor.constraint(equalTo: ingredientsCollectionView.bottomAnchor, constant: 8),
            stepsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stepsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stepsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Additional UI setup can go here, e.g., setting the view's background color
        view.backgroundColor = .appCream
    }
    
    func generateRecipe() {
        OpenAIService.shared.generateRecipe(from: recipeDetails) { [weak self] generatedRecipe in
            DispatchQueue.main.async {
                guard let self = self, let recipeText = generatedRecipe else { return }
                if let parsedRecipe = OpenAIService.shared.parseRecipe(from: recipeText) {
                    self.recipe = parsedRecipe
                    self.titleLabel.text = parsedRecipe.title
                    self.ingredientsCollectionView.isHidden = false
                    self.stepsLabel.text = parsedRecipe.steps.joined(separator: "\n\n")
                    self.ingredientsCollectionView.reloadData()
                } else {
                    // Handle parsing error or display a placeholder message
                }
            }
        }
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipe?.ingredients.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCollectionViewCell", for: indexPath) as? IngredientsCollectionViewCell else {
                    fatalError("Unable to dequeue IngredientsCollectionViewCell")
                }
        cell.ingredientLabel.text = self.recipe?.ingredients[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5 // You can adjust padding
        let label = UILabel(frame: .zero)
        label.text = self.recipe.ingredients[indexPath.row]
        label.sizeToFit()
        let size = label.frame.size
        let width = max(size.width + padding, 80) // Ensure minimum width and add padding
        let height = max(size.height + padding, 20) // Ensure minimum height and add padding
        return CGSize(width: width, height: height)
    }
    
    
    
}
