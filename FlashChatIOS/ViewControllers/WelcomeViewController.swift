import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private let viewModel = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
        titleLabel.animateText(viewModel.titleText)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: K.welcomeSegue, sender: self)
        }
    }
}
