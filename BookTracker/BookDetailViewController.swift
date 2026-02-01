import UIKit
import CoreData

class BookDetailViewController: UIViewController {
    var bookItem: BookItem!
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let toReadButton = UIButton( type: .system)
    private let readButton = UIButton( type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Книга"
        
        [titleLabel, authorLabel, descriptionLabel, toReadButton, readButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        authorLabel.font = .systemFont(ofSize: 18)
        authorLabel.textColor = .black.withAlphaComponent(0.7)
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        toReadButton.setTitle("Хочу прочитать", for: .normal)
        toReadButton.backgroundColor = .systemPink
        toReadButton.setTitleColor(.white, for: .normal)
        toReadButton.layer.cornerRadius = 30
        toReadButton.addTarget(self, action: #selector (toReadTapped), for: .touchUpInside)
        
        readButton.setTitle("Уже прочитала", for: .normal)
        readButton.backgroundColor = .systemPink
        readButton.setTitleColor(.white, for: .normal)
        readButton.layer.cornerRadius = 30
        readButton.addTarget(self, action: #selector (readTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            toReadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            toReadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toReadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toReadButton.heightAnchor.constraint(equalToConstant: 50),

            readButton.topAnchor.constraint(equalTo: toReadButton.bottomAnchor, constant: 15),
            readButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        titleLabel.text = bookItem.title
        authorLabel.text = bookItem.author
        descriptionLabel.text = bookItem.description.isEmpty ? "Нет описания" : bookItem.description
    }
    
    @objc private func toReadTapped() {
        saveBook(status: "toRead")
    }
    
    @objc private func readTapped() {
        saveBook(status: "read")
    }
    
    private func saveBook (status: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", bookItem.id)
        
        do {
            if let existing = try? context.fetch(fetchRequest).first {
            existing.status = status
            } else {
            let book = Book(context: context)
            book.id = bookItem.id
            book.title = bookItem.title
            book.author = bookItem.author
            book.descriptionText = bookItem.description
            book.thumbnailURL = bookItem.thumbnailURL
            book.status = status
        }
            try context.save()
            print("Книга сохранена: \(bookItem.title)")
            let alert = UIAlertController(title: "Сохранено", message: "Книга добавлена в список", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            } catch {
                print("Ошибка сохранения: \(error)")
            }
    
    }
}
