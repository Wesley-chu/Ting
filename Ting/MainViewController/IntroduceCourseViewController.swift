//
//  IntroduceCourseViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit

class IntroduceCourseViewController: UIViewController {
    
    @IBOutlet weak var level_C: UIButton!
    @IBOutlet weak var level_B: UIButton!
    @IBOutlet weak var level_A: UIButton!
    @IBOutlet weak var level_S: UIButton!
    
    static func instantiate() -> IntroduceCourseViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroduceCourseViewController") as! IntroduceCourseViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    
    @IBAction func course(_ sender: UIButton) {
        switch sender {
        case level_C:
            performSegue(withIdentifier: "segue_gmrList", sender: level.C)
        case level_B:
            performSegue(withIdentifier: "segue_gmrList", sender: level.B)
        case level_A:
            performSegue(withIdentifier: "segue_gmrList", sender: level.A)
        case level_S:
            performSegue(withIdentifier: "segue_gmrList", sender: level.S)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_gmrList"{
            if let toGrammarListViewController = segue.destination as? GrammarListViewController{
                toGrammarListViewController.postedLevel = sender as! level
            }
        }
    }
    
    
    
    
    
}
