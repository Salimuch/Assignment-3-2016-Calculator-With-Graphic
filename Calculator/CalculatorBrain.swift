//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Артем on 19/08/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?
    private var currentPriority = 1
    private var descriptionAccumulator = " " {
        didSet {
            if pending == nil {
                currentPriority = 1
            }
        }
    }
    private var internalProgram = [AnyObject]()
    
    var variableValues = [String:Double]() {
        didSet {
            program = internalProgram
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(pending!.descriptionOperand,
                                                    pending!.descriptionOperand != descriptionAccumulator ?descriptionAccumulator : "")
            }
        }
    }
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        if operations[operation] != nil {
                            performOperation(operation)
                        } else {
                            setOperand(operation)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
        descriptionAccumulator =  String(format: "%g", operand)
    }
    
    func setOperand(variable: String) {
        accumulator = variableValues[variable] ?? 0
        internalProgram.append(variable)
        descriptionAccumulator = variable
    }
    
    private func executePendingBinaryOpeartion() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    private func clear() {
        accumulator = 0.0
        descriptionAccumulator = " "
        pending = nil
        currentPriority = 1
        internalProgram.removeAll(keepCapacity: false)
    }
    
    private func clearVariables() {
        variableValues = [:]
    }
    
    func undoLast() {
        guard !internalProgram.isEmpty else { clear(); return}
        internalProgram.removeLast()
        program = internalProgram
        
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let priority):
                executePendingBinaryOpeartion()
                if currentPriority < priority {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator,
                                                     descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals :
                executePendingBinaryOpeartion()
            case .ClearOperation:
                clear()
                clearVariables()
            }
        }
    }
    
    private var operations: Dictionary <String, Operation> = [
        "√" : Operation.UnaryOperation(sqrt, { "√(" + $0 + ")" }),
        "³√" : Operation.UnaryOperation(cbrt, { "³√" + $0 + ")" }),
        "x²" : Operation.UnaryOperation({ $0 * $0 }, { "(" + $0 + ")²" }),
        "x³" : Operation.UnaryOperation({ $0 * $0 * $0 }, { "(" + $0 + ")³" }),
        "xʸ" : Operation.BinaryOperation({ pow($0, $1) }, { "(" + $0 + ")^" + $1 }, 0),
        "e" : Operation.Constant(M_E),
        "eˣ" : Operation.UnaryOperation({ pow(M_PI, $0) }, { "e^" + $0 }),
        "sin" : Operation.UnaryOperation(sin, { "sin(" + $0 + ")" }),
        "cos" : Operation.UnaryOperation(cos, { "cos(" + $0 + ")" }),
        "tan" : Operation.UnaryOperation(tan, { "tan(" + $0 + ")" }),
        "ln" : Operation.UnaryOperation(log, { "ln(" + $0 + ")" }),
        "π" : Operation.Constant(M_PI),
        "x⁻¹" : Operation.UnaryOperation({ 1 / $0 }, { $0 + "^(-1)" }),
        "×" : Operation.BinaryOperation({ $0 * $1 }, { $0 + "*" + $1 }, 1),
        "÷" : Operation.BinaryOperation({ $0 / $1 }, { $0 + "/" + $1 }, 1),
        "+" : Operation.BinaryOperation({ $0 + $1 }, { $0 + " + " + $1 }, 0),
        "−" : Operation.BinaryOperation({ $0 - $1 }, { $0 + "-" + $1 }, 0),
        "±" : Operation.UnaryOperation({ -$0 }, { "-(" + $0 + ")" }),
        "=" : Operation.Equals,
        "AС" : Operation.ClearOperation
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double,Double) -> Double, (String, String) -> String, Int)
        case Equals
        case ClearOperation
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    typealias PropertyList = AnyObject
}
