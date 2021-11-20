//
//  NewVehicleViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import UIKit

class NewCarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавить новое авто"
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func TestAddSelected(_ sender: Any) {
        let vc = NewCarTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ManualAddSelected(_ sender: Any) {
//        let vc = NewCarManualAddViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
