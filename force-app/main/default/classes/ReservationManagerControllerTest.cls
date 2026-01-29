@IsTest
private class HelloWorldTest {
    @IsTest
    static void testSayHello() {
        // Call the method
        String result = HelloWorld.sayHello();
        
        // Verify the result
        System.assertEquals('Hello, Salesforce!', result);
    }
}
