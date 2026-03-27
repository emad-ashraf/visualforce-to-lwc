@IsTest
private class ReservationManagerControllerTest {
    @IsTest
    static void testSayHello() {
        // Call the method
        String result = ReservationManagerController.sayHello();
        
        // Verify the result
        System.assertEquals('Hello, Salesforce!', result);
    }
}
