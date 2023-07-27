//
//  Common.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/24/23.
//

import UIKit


public func createResizedImage(imageName: String, size: CGSize) -> UIImage? {
    let originalImage = UIImage(named: imageName)
    let resizedImage = resizeImage(originalImage, targetSize: size)
    return resizedImage
}


public func createResizedImageTabBarItem(imageName: String, size: CGSize, title: String) -> UITabBarItem {
    let originalImage = UIImage(named: imageName)
    let resizedImage = resizeImage(originalImage, targetSize: size)
    let tabBarItem = UITabBarItem(title: title, image: resizedImage, selectedImage: resizedImage)
    return tabBarItem
}

private func resizeImage(_ image: UIImage?, targetSize: CGSize) -> UIImage? {
    guard let image = image else { return nil }
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    let resizedImage = renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: targetSize))
    }
    
    return resizedImage.withRenderingMode(.alwaysOriginal)
}

func validateWholeNumbers(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool{
    if(string.isEmpty){
        return true;
    }
    
    let allowedCharacters = CharacterSet(charactersIn: "0123456789")
    let filteredString = string.components(separatedBy: allowedCharacters.inverted).joined()
    return string == filteredString
}

func roundToTwoDecimalPlaces(_ value: Double) -> Double {
    let multiplier = pow(10.0, 2.0)
    return round(value * multiplier) / multiplier
}

func validateWholeNumbersWithRange(_ textField: UITextField, _ range: NSRange, _ string: String, _ minValue: Int, _ maxValue: Int) -> Bool{
    if(string.isEmpty){
        return true;
    }
    
    let allowedCharacters = CharacterSet(charactersIn: "0123456789")
    let filteredString = string.components(separatedBy: allowedCharacters.inverted).joined()
    let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: filteredString) ?? filteredString
    if let number = Int(updatedText), (minValue...maxValue).contains(number) {
        return true
    } else {
        return false
    }
}

func validateDecimalNumbersWithRange(_ textField: UITextField, _ range: NSRange, _ string: String, _ maxDecimalPlaces: Int, _ minValue: Double, _ maxValue: Double) -> Bool{
    if string.isEmpty {
        return true
    }
    
    guard let text = textField.text, let range = Range(range, in: text) else {
        return true
    }
    let input = text.replacingCharacters(in: range, with: string)
    let decimalSeparator = Locale.current.decimalSeparator ?? "."
    let components = input.components(separatedBy: decimalSeparator)
    if components.count > maxDecimalPlaces {
        return false
    }
    
    if components.count == maxDecimalPlaces {
        let decimalPart = components[1]
        if decimalPart.count > maxDecimalPlaces {
            return false
        }
    }
    
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    if let number = formatter.number(from: input), number.doubleValue >= minValue {
        return number.doubleValue <= maxValue
    }
    
    return false
    
}

func validateDecimalNumbers(_ textField: UITextField, _ range: NSRange, _ string: String, _ maxDecimalPlaces: Int) -> Bool{
    if string.isEmpty {
        return true
    }
    
    guard let text = textField.text, let range = Range(range, in: text) else {
        return true
    }
    let input = text.replacingCharacters(in: range, with: string)
    let decimalSeparator = Locale.current.decimalSeparator ?? "."
    let components = input.components(separatedBy: decimalSeparator)
    if components.count > maxDecimalPlaces {
        return false
    }
    
    if components.count == maxDecimalPlaces {
        let decimalPart = components[1]
        if decimalPart.count > maxDecimalPlaces {
            return false
        }
    }
    
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    if let number = formatter.number(from: input), number.doubleValue >= 0 {
        return true
    }
    
    return false
    
}

func removeThousandSeparators(from text: String) -> String {
    return text.replacingOccurrences(of: ",", with: "")
}


func addThousandSeparators(to text: String) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal

    if let number = formatter.number(from: text) {
        return formatter.string(from: number)
    }

    return nil
}

func loadPropertyFile(fileName: String) -> [String: Any]? {
    if let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
        let data = FileManager.default.contents(atPath: path) {
        do {
            if let plistObject = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                return plistObject
            }
        } catch {
            print("Error reading property file: \(error)")
        }
    }
    return nil
}
