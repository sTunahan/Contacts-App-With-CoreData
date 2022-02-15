
import UIKit

class UpdatePersonVC: UIViewController {
    //to process coredata
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    var person:Persons?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name=person?.name,let phone=person?.phone{
            nameTextField.text = name
            numberTextField.text = phone
        }
    }
    
    
    @IBAction func updateButton(_ sender: Any) {
        
//Update Process
        if let person = person ,let name = nameTextField.text,let phone = numberTextField.text {
            
            person.name = name
            person.phone = phone
            
            
            appDelegate.saveContext()
        }
    }
}
