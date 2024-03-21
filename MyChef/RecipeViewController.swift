import UIKit

class RecipeViewController: UIViewController {
    
    var recipeDetails: Recipe!
    var recipeTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateRecipe()
    }
    
    private func setupUI() {
        // Initialize the UITextView and add it to the view
        recipeTextView = UITextView()
        recipeTextView.isEditable = false
        recipeTextView.translatesAutoresizingMaskIntoConstraints = false
        recipeTextView.font = UIFont.systemFont(ofSize: 16)
        recipeTextView.textColor = .black
        recipeTextView.backgroundColor = .white
        view.addSubview(recipeTextView)

        // Set constraints for the UITextView
        NSLayoutConstraint.activate([
            recipeTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            recipeTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recipeTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recipeTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // Additional UI setup can go here, e.g., setting the view's background color
        view.backgroundColor = .systemBackground
    }
    
    func generateRecipe() {
        OpenAIService.shared.generateRecipe(from: recipeDetails) { [weak self] generatedRecipe in
            DispatchQueue.main.async {
                guard let self = self, let recipeText = generatedRecipe else { return }
                self.recipeTextView.text = recipeText
            }
        }
    }
}
