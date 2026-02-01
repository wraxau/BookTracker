import UIKit
import CoreData

class LibraryViewController: UITableViewController {
    private var toReadBooks: [Book] = []
    private var readBooks: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои книги"
        loadBooks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBooks() 
    }

    private func loadBooks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        do {
            let allBooks = try context.fetch(fetchRequest)
            toReadBooks = allBooks.filter { $0.status == "toRead" }
            readBooks = allBooks.filter { $0.status == "read" }
            tableView.reloadData()
        } catch {
            print("Ошибка загрузки книг: \(error)")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Хочу прочитать" : "Уже прочитала"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? toReadBooks.count : readBooks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "LibraryCell")
        let book = indexPath.section == 0 ? toReadBooks[indexPath.row] : readBooks[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext

            let book = indexPath.section == 0 ? toReadBooks[indexPath.row] : readBooks[indexPath.row]
            context.delete(book)

            do {
                try context.save()
                loadBooks()
            } catch {
                print("Ошибка удаления: \(error)")
            }
        }
    }
}
