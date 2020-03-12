//
//  Calculator.swift
//  Wayconomy
//
//  Created by Erick Almeida on 10/03/20.
//  Copyright © 2020 Erick Almeida. All rights reserved.
//

import Foundation

class Calculator {
    
    var distanceTraveled: Double;
    var spentFuel: Double;
    var efficiency: Double;
    var fuelPrice: Double
    var pricePerKm: Double;
    
    init() {
        self.distanceTraveled = 0
        self.spentFuel = 0
        self.efficiency = 0
        self.fuelPrice = 0
        self.pricePerKm = 0
    }
    
    func performEfficiencyCalculation() {
        efficiency = distanceTraveled / spentFuel
    }
    
    func performPricePerKmCalculation() {
        pricePerKm = fuelPrice / efficiency
    }
    
    func formatNumber(number: Double, isKmPerLiter: Bool = false, isCurrency: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        let formattedAmount: String
        if (isKmPerLiter) {
            formattedAmount = formatter.string(from: number as NSNumber)! + " km/l"
        } else if (isCurrency) {
            formatter.minimumFractionDigits = 2
            formattedAmount = "R$ " + formatter.string(from: number as NSNumber)!
        } else {
            formattedAmount = formatter.string(from: number as NSNumber)!
        }
        return formattedAmount
    }
    
    func getFormattedEfficiency() -> String? {
        if (distanceTraveled != 0 && spentFuel != 0) {
            performEfficiencyCalculation()
            return formatNumber(number: efficiency, isKmPerLiter: true)
        }
        return nil
    }
    
    func getFormattedPricePerKm() -> String? {
        if (efficiency != 0 && fuelPrice != 0) {
            performPricePerKmCalculation()
            return formatNumber(number: pricePerKm, isCurrency: true)
        }
        return nil
    }
    
    
}
