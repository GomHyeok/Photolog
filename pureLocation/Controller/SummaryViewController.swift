//
//  SummaryViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/17.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var token : String = ""
    var id : Int = 0
    var travelId : Int = 0
    var datas : CalculateResponse?

    @IBOutlet weak var NameAndPhoto: UILabel!
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var EndDay: UILabel!
    @IBOutlet weak var StartDay: UILabel!
    @IBOutlet weak var PlaceNum: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datas)
    }

}
