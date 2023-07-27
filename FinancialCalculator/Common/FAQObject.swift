//
//  FAQObject.swift
//  FinancialCalculator
//
//  Created by user235755 on 7/30/23.
//

import Foundation

class FAQ: Codable {
    var title: String?
    var steps: [String] = []
    
    init(title: String? = nil, steps: [String]) {
        self.title = title
        self.steps = steps
    }
}

