//
//  GeneralFactory.swift
//  TwitterClone
//
//  Created by Саша Восколович on 27.10.2023.
//

import Foundation

protocol GeneralFactoryProtocol {
    var buttonFactory: ButtonFactoryProtocol { get set }
    var textFieldFactory: TextFieldFactory { get set }
    var labelFactory: LabelFactoryProtocol { get set }
}



final class GeneralFactory: GeneralFactoryProtocol {
    
    var labelFactory: LabelFactoryProtocol
    
    var buttonFactory: ButtonFactoryProtocol
    
    var textFieldFactory: TextFieldFactory
    
    init(buttonFactory: ButtonFactoryProtocol, textFieldFactory: TextFieldFactory, labelFactory: LabelFactoryProtocol) {
        self.buttonFactory = buttonFactory
        self.textFieldFactory = textFieldFactory
        self.labelFactory = labelFactory
    }
}
