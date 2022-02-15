
import UIKit

class DetailPersonVC: UIViewController {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var person:Persons?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name=person?.name,let phone=person?.phone{
            nameLabel.text = name
            numberLabel.text = phone
        }
    
    }
    

  

}
