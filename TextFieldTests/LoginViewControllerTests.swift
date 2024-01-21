//
//  LoginViewControllerTests.swift
//  TextFieldTests
//
//  Created by Саша Восколович on 21.01.2024.
//

import XCTest
@testable import TwitterClone

final class LoginViewControllerTests: XCTestCase {

    
    private var sut: LoginViewController!
    private var model: AuthenticationViewModel!
    
    
    override func setUp() {
        super.setUp()
        model = AuthenticationViewModel(userAuth: UserAuth(), userDatabaseManager: UserDatabaseManager())
        sut = LoginViewController(authenticationViewModel: model, commonFactory: GeneralFactory(buttonFactory: ButtonFactory(), textFieldFactory: TextFieldFactory(), labelFactory: LabelFactory()))
        sut.loadViewIfNeeded()
    }
   
    
    override func tearDown() {
        sut = nil
        model = nil
        super.tearDown()
    }

    func test_fields_shouldBeConnected() {
        XCTAssertNotNil(sut.emailTextField, "emailTextField")
        XCTAssertNotNil(sut.passwordTextField, "passwordTextField")
    }
    
    func test_emailTextField_attributesShouldBeSet() {
        let textField = sut.emailTextField
        XCTAssertEqual(textField.keyboardType, .emailAddress, "keyboardType")
        XCTAssertEqual(textField.autocorrectionType, .no, "autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
    }
    
    func test_passwordTextField_atrributesShouldBeSet() {
        let textField = sut.passwordTextField
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
    }
    
    func test_shouldChangeCharacters_emailAdressWithSpaces_shouldPreventChange() {
        let allowChange = shouldChangeCharacters(in: sut.emailTextField, replacement: "a b")
        XCTAssertEqual(allowChange, false)
    }
    
    func test_shouldChangeCharacters_emailAdressWithoutSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.emailTextField, replacement: "acb")
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldChangeCharacters_passwordWithSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.passwordTextField, replacement: "a b")
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldChangeCharacters_passwordWithoutSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.passwordTextField, replacement: "abc")
        XCTAssertEqual(allowChange, true)
    }
    
    func test_shouldReturn_withEmailAdress_shouldMoveInputFocusToPassword() {
        putInViewHierarchy(sut)
        shouldReturn(in: sut.emailTextField)
        XCTAssertTrue(sut.passwordTextField.isFirstResponder)
    }
    
    func test_shouldReturn_withPassword_shouldDismissKeyboard() {
        putInViewHierarchy(sut)
        sut.passwordTextField.becomeFirstResponder()
        
        XCTAssertEqual(sut.passwordTextField.isFirstResponder, true, "precondition")
        
        shouldReturn(in: sut.passwordTextField)
        
        XCTAssertFalse(sut.passwordTextField.isFirstResponder)
        
    }
}
