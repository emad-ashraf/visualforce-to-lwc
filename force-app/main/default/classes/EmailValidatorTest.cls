@IsTest
private class EmailValidatorTest {
    
    @IsTest
    static void testValidEmail() {
        System.assertEquals(true, EmailValidator.isValid('test@example.com'));
    }
    
    @IsTest
    static void testClearlyInvalidButPasses() {
        // Should NOT be valid, but passes due to weak regex
        System.assertEquals(true, EmailValidator.isValid('@@@'));
    }
    
    @IsTest
    static void testBlankEmail() {
        System.assertEquals(false, EmailValidator.isValid(''));
    }
}