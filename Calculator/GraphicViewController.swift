//
//  GraphicViewController.swift
//  Calculator
//
//  Created by Артем on 02/09/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController {
    
    
    @IBOutlet weak var graphicView: GraphicView! {
        didSet {
            let pinchGuesterRecognizer = UIPinchGestureRecognizer(target: graphicView,
                                                                  action: #selector(graphicView.scale(_:)))
            graphicView.addGestureRecognizer(pinchGuesterRecognizer)
            
            let panGuesterRecognizer = UIPanGestureRecognizer(target: graphicView,
                                                              action: #selector(graphicView.shiftOrigin(_:)))
            graphicView.addGestureRecognizer(panGuesterRecognizer)
            
            let tapGuesterRecognizer = UITapGestureRecognizer(target: graphicView,
                                                              action: #selector(graphicView.changeOrigin(_:)))
            tapGuesterRecognizer.numberOfTapsRequired = 2
            graphicView.addGestureRecognizer(tapGuesterRecognizer)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
