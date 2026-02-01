import UIKit

class SplashViewController: UIViewController {
    
    private let appName = UILabel()
    private let appImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        appName.text = "Welcome to BookTracker"
        appName.font = UIFont(name: "Snell Roundhand", size: 20.0)
        appName.textColor = .white
        appName.textAlignment = .center
        appName.numberOfLines = 0
        appName.alpha = 0
        appName.translatesAutoresizingMaskIntoConstraints = false
        
        appImageView.image = UIImage(systemName: "book.circle.fill")
        appImageView.contentMode = .scaleAspectFit
        appImageView.tintColor = .white
        appImageView.alpha = 0
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(appName)
        view.addSubview(appImageView)
        
        NSLayoutConstraint.activate([
            appImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appImageView.bottomAnchor.constraint(equalTo: appName.topAnchor, constant: -40),
            appImageView.widthAnchor.constraint(equalToConstant: 140),
            appImageView.heightAnchor.constraint(equalToConstant: 140),

            appName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2.0) {
            self.appName.alpha = 1.0
            self.appImageView.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showMainScreen()
        }
    }
    
    private func showMainScreen() {
        guard let window = view.window else { return }
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let libraryVC = LibraryViewController()
        libraryVC.tabBarItem = UITabBarItem(title: "Мои книги", image: UIImage(systemName: "books.vertical"), tag: 1)
        
        let searchNav = UINavigationController(rootViewController: searchVC)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNav, libraryNav]
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = tabBarController
            },
            completion: nil
        )
    }
}
