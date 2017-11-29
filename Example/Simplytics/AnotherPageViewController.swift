//
//  AnotherPageViewController.swift
//  Simplytics_Example
//
//  Created by Quinton Wall on 11/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AnotherPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        simplytics.logEvent("Button Tapped", funnel: "Featured", withProperties: ["Button Name" : sender.titleLabel?.text, "Screen" : "Another Page"])
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
