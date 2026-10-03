import XCTest
@testable import Intellipaat_App

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    private var sut: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        sut = LoginViewModel(authRepository: AuthRepository())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testValidation_emptyEmail_setsEmailError() {
        // Arrange
        sut.email = ""
        sut.password = "validPassword"
        
        // Act
        let isValid = sut.validate()
        
        // Assert
        XCTAssertFalse(isValid)
        XCTAssertEqual(sut.emailError, "Email is required")
    }
    
    func testValidation_invalidEmailFormat_setsInvalidEmailError() {
        // Arrange
        sut.email = "invalid-email-format"
        sut.password = "validPassword"
        
        // Act
        let isValid = sut.validate()
        
        // Assert
        XCTAssertFalse(isValid)
        XCTAssertEqual(sut.emailError, "Enter a valid email")
    }
    
    func testValidation_emptyPassword_setsPasswordError() {
        // Arrange
        sut.email = "test@test.com"
        sut.password = ""
        
        // Act
        let isValid = sut.validate()
        
        // Assert
        XCTAssertFalse(isValid)
        XCTAssertEqual(sut.passwordError, "Password is required")
    }
    
    func testLogin_validCredentials_succeedsAndSetsLoggedIn() async {
        // Arrange
        sut.email = "test@test.com"
        sut.password = "password"
        
        // Act
        await sut.login()
        
        // Assert
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNotNil(sut.currentUser)
        XCTAssertEqual(sut.currentUser?.email, "test@test.com")
        XCTAssertNil(sut.generalError)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLogin_invalidCredentials_failsAndSetsErrorMessage() async {
        // Arrange
        sut.email = "wrong@test.com"
        sut.password = "wrongpass"
        
        // Act
        await sut.login()
        
        // Assert
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.currentUser)
        XCTAssertEqual(sut.generalError, "Invalid email or password")
        XCTAssertFalse(sut.isLoading)
    }
}
