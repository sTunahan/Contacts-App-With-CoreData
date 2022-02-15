
import UIKit
import CoreData

//coredata global variable
let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {

    //to process coredata
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var personsTableView: UITableView!
    
    var personsList = [Persons]()
    
    var searchBoolean = false
    var searchWord:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsTableView.delegate = self
        personsTableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    //for updating the screen on page changes
    override func viewWillAppear(_ animated: Bool) {
        
        if searchBoolean == true{
            searchPerson(personName: searchWord!)
        }
        if searchBoolean == false {
            takeAllPersons()
        }
        
        
        personsTableView.reloadData() //tableview for continuous listening
    }
    
    
    
    // Sending data to pages with the prepare method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let receivedIndex = sender as? Int
        
        if segue.identifier == "toDetail"{
            
            let togoVC = segue.destination as! DetailPersonVC
            togoVC.person = personsList[receivedIndex!]
            
        }
        if segue.identifier == "toUpdate"{
            let togoVC = segue.destination as! UpdatePersonVC
            togoVC.person = personsList[receivedIndex!]
        }
    }
    
    //process of retrieving data stored in memory
    func takeAllPersons (){
        do{
            personsList = try context.fetch(Persons.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    
    // for people to be listed by search result
    func searchPerson (personName:String){
        
        let fetchRequest:NSFetchRequest<Persons> = Persons.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", personName)
        do{
            personsList = try context.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }
}

/// for  TableView - Protocol
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = personsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! HomePageVC
        
        cell.personLabel.text = "\(person.name!) - \(person.phone!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteActionButton = UIContextualAction(style: .destructive, title:"Delete")
        {
            (contextualAction , view , boolValue) in
            

            let person = self.personsList[indexPath.row]
            self.context.delete(person)
            appDelegate.saveContext()
            if self.searchBoolean == true{
                self.searchPerson(personName: self.searchWord!)
            }
            if self.searchBoolean == false {
                self.takeAllPersons()
            }
            self.personsTableView.reloadData()
        }

        let updateActionButton = UIContextualAction(style: .normal, title:"Update")
        {
            (contextualAction , view , boolValue) in
            
            self.performSegue(withIdentifier: "toUpdate", sender: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteActionButton,updateActionButton])
        
    }
}

/// for SearchBar
extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("aranan: \(searchText)")
        
        self.searchWord = searchText
        
        if searchText == "" {
            searchBoolean = false // unable to search
            takeAllPersons()
        }
        else{
            searchBoolean = true
            searchPerson(personName: searchWord!)
        }
        personsTableView.reloadData()
    }
    
}

