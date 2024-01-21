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
        XCTAssertEqual(sut.emailTextField.keyboardType, .emailAddress)
        XCTAssertEqual(sut.emailTextField.autocorrectionType, .no)
        XCTAssertEqual(sut.emailTextField.returnKeyType, .next)
    }
    
}
