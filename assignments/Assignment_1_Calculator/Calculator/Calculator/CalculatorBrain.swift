//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Dulio Denis on 2/19/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import Foundation

// global support functions
func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

struct CalculatorBrain {
    
    // optional on initialization = not set
    private var accumulator: Double?
    
    // private enum specifying operation types
    // with an associated value
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double,Double) -> Double)
        case equals
    }
    
    // private dictionary of operations
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unary(sqrt),
        "cos" : Operation.unary(cos),
        "±" : Operation.unary(changeSign),
        "×" : Operation.binary(multiply),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unary(let f):
                if accumulator != nil {
                    accumulator = f(accumulator!)
                }
            case .binary(let f):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // Private mutating func for performing pending binary operations
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    // Private optional Pending Binary Operation
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // embedded private struct to support binary operations
    // with a constant function and pending first operand
    // doesn't need mutating since its just returning a value
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // mark method as mutating in order to assign to property
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    // return an optional since the accumulator can be not set
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
