//
//  ViewController.swift
//  Wayconomy
//
//  Created by Erick Almeida on 02/03/20.
//  Copyright © 2020 Erick Almeida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var distanceTraveledTextField: UITextField!
    @IBOutlet var spentFuelTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var calcHelpLabel: UILabel!
    @IBOutlet var efficiencyResultView: UIView!
    @IBOutlet var calcTitleLabel: UILabel!
    @IBOutlet var calcTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var efficiencyView: UIView!
    @IBOutlet var pricePerKmView: UIView!
    @IBOutlet var changeCalcTypeButton: UIButton!
    @IBOutlet var efficiencyTextField: UITextField!
    @IBOutlet var fuelPriceTextField: UITextField!
    @IBOutlet var backgroundImage: UIImageView!
    
    let calculator: Calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalcType(type: 0)
        toggleResultStatus(viewable: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
         if #available(iOS 13.0, *) {
              calcTypeSegmentedControl.layer.borderColor = UIColor.white.cgColor
              calcTypeSegmentedControl.selectedSegmentTintColor = UIColor.white

              let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
              calcTypeSegmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)

              let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
              calcTypeSegmentedControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
          }
        
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
    }
    
    func readTextFieldAsDouble(textField: UITextField!) -> Double? {
        if (textField.text!.contains(",")) {
            return Double(textField.text!.replacingOccurrences(of: ",", with: "."))
        }
        return Double(textField.text!)
    }
    
    func toggleResultStatus(viewable: Bool) {
        if (viewable) {
            efficiencyResultView.isHidden = false
            calcHelpLabel.isHidden = true
        } else {
            efficiencyResultView.isHidden = true
            calcHelpLabel.isHidden = false
        }
    }
    
    @IBAction func onPressChangeCalcTypeButton() {
        calcTypeSegmentedControl.selectedSegmentIndex = 1
        setCalcType(type: 1)
    }
    
    @IBAction func calcTypeSelectorChanged() {
        setCalcType(type: calcTypeSegmentedControl.selectedSegmentIndex)
    }
    
    func setCalcType(type: Int) {
        if (type == 0) {
            // Rendimento
            efficiencyView.isHidden = false;
            pricePerKmView.isHidden = true;
            calcTitleLabel.text = "Rendimento"
            changeCalcTypeButton.isHidden = false;
            backgroundImage.image = UIImage(named: "Background")
            onUpdateEfficiencyTextFields()
        } else if (type == 1) {
            // Preço por km
            if (calculator.efficiency != 0) {
                efficiencyTextField.text = calculator.formatNumber(number: calculator.efficiency)
            }
            efficiencyView.isHidden = true;
            pricePerKmView.isHidden = false;
            calcTitleLabel.text = "Preço por km"
            changeCalcTypeButton.isHidden = true;
            backgroundImage.image = UIImage(named: "Background Alternative")
            onUpdatePricePerKmTextFields()
        }
        
    }
    
    func setCalcHelpText(calcTypeIndex: Int, isTextFieldEmpty: Bool = false, isTextFieldEqualOrSmallerThanZero: Bool = false) {
        let calcTypeName: String
        
        if (calcTypeIndex == 0) {
            calcTypeName = "rendimento"
        } else {
            calcTypeName = "preço por km"
        }
        
        if (isTextFieldEmpty) {
            calcHelpLabel.text = "Quando você inserir os dados, o \(calcTypeName) calculado aparecerá aqui."
        } else if (isTextFieldEqualOrSmallerThanZero) {
            calcHelpLabel.text = "Por favor, insira um valor maior que zero nos campos para calcular o \(calcTypeName)."
        }
        
    }
    
    @IBAction func onUpdateEfficiencyTextFields() {
        guard let distanceTraveled = readTextFieldAsDouble(textField: distanceTraveledTextField) else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 0, isTextFieldEmpty: true)
            return
        }
        
        guard let spentFuel = readTextFieldAsDouble(textField: spentFuelTextField) else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 0, isTextFieldEmpty: true)
            return
        }
        
        calculator.distanceTraveled = distanceTraveled
        calculator.spentFuel = spentFuel
        
        guard let result = calculator.getFormattedEfficiency() else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 0, isTextFieldEqualOrSmallerThanZero: true)
            return
        }
        
        toggleResultStatus(viewable: true)
        resultLabel.text = result
        
    }
    
    
    @IBAction func onUpdatePricePerKmTextFields() {
        guard let efficiency = readTextFieldAsDouble(textField: efficiencyTextField) else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 1, isTextFieldEmpty: true)
            return
        }
        
        guard let fuelPrice = readTextFieldAsDouble(textField: fuelPriceTextField) else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 1, isTextFieldEmpty: true)
            return
        }
        
        calculator.efficiency = efficiency
        calculator.fuelPrice = fuelPrice
        
        guard let result = calculator.getFormattedPricePerKm() else {
            toggleResultStatus(viewable: false)
            setCalcHelpText(calcTypeIndex: 1, isTextFieldEqualOrSmallerThanZero: true)
            return
        }
        
        toggleResultStatus(viewable: true)
        resultLabel.text = result
    }
    
    @IBAction func onPressShareButton() {
        shareResult()
    }
    
    func shareResult() {
        let shareText: [String];
        if (calcTypeSegmentedControl.selectedSegmentIndex == 0) {
            shareText = [ "O rendimento calculado é de \(resultLabel.text!)." ]
        } else {
            shareText = [ "O preço por km calculado é de \(resultLabel.text!)." ]
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
}
