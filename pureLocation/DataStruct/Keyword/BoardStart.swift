
import Foundation
import UIKit

class BoardStart : UITableViewCell {
    
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Creator: UILabel!
    @IBOutlet weak var TableImage: UIImageView!
    @IBOutlet weak var Descript: UITextView!
    
    var gradientView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView?.frame = TableImage.bounds
        gradientView?.layer.sublayers?.first?.frame = TableImage.bounds
    }
    
}
