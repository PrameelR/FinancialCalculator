//
//  ViewController.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/23/23.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: myView.bounds,
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 10.0, height: 10.0)).cgPath
        
        // Apply the mask to the view's layer
        myView.layer.mask = maskLayer(*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tabviewcontroller = segue.destination as? TabBarViewController;
        
        tabviewcontroller?.identifier = segue.identifier
    }
    
}

