
import UIKit

class AddPersonVC: UIViewController {
    // to process coredata
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    //Here we are recording the information to coreData.
    @IBAction func addButton(_ sender: Any) {
        
        if let name = nameTextField.text,let phone = numberTextField.text {
            
            let personİnformation = Persons(context: context)
            
            personİnformation.name = name
            personİnformation.phone = phone
            appDelegate.saveContext()
        }
        
        
        
    }
    
    

}
