//
//  ViewController.swift
//  Calculator
//
//  Created by Артем on 19/08/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!

    @IBAction func pullM(sender: UIButton) {
        brain.setOperand(sender.currentTitle!)
        displayValue = brain.result
    }
    @IBAction func pushM(sender: UIButton) {
        userInTheMiddleOfTyping = false
        if let value = displayValue {
            brain.variableValues["M"] = value
            displayValue = brain.result
        }
    }
    
    private var userInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    private var displayValue: Double? {
        get {
            if let value = Double(display.text!) {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = String(value)
                
                history.text = brain.description + (brain.isPartialResult ? " ..." : " =")
            } else {
                display.text = " "
                history.text = " "
                userInTheMiddleOfTyping = false
            }
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func touchBackspace(sender: UIButton) {
        if userInTheMiddleOfTyping {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        } else {
            brain.undoLast()
            displayValue = brain.result
        }
        if display.text!.isEmpty {
            userInTheMiddleOfTyping = false
            displayValue = 0
        }
        
    }
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if userInTheMiddleOfTyping {
            if (digit != ".") || (textCurrentlyInDisplay.rangeOfString(".") == nil) {
            display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        if userInTheMiddleOfTyping {
            if let value = displayValue {
                brain.setOperand(value)
            }
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? GraphicViewController {
                return true
            }
        }
        return false
    }

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

