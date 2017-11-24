//
//  FeaturedViewController.swift
//  Simplytics_Example
//
//  Created by Quinton Wall on 11/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        simplytics.logScreen("Featured View", funnel: "Featured", withProperties: ["Lifecycle" : "Loaded"])


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        simplytics.logEvent("Button Tapped", funnel: "Featured", withProperties: ["Button Name" : sender.titleLabel?.text])
        performSegue(withIdentifier: "showpage2", sender: sender)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         simplytics.logEvent("Navigation", funnel: "Featured", withProperties: ["From" : "FeaturedView", "To" : "Page2"])
    }
    

}
