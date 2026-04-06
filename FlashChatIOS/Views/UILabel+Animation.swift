import UIKit

extension UILabel {
    func animateText(_ text: String) {
        self.text = ""
        
        for (index, letter) in text.enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.2 * Double(index), repeats: false) { _ in
                self.text?.append(letter)
            }
        }
    }
}
