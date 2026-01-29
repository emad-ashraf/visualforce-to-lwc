@IsTest
public class ReservationManagerControllerTest {
    
    // Test data setup
    @TestSetup
    static void setup() {
        // Accounts and Contacts
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<5;i++){
            accts.add(new Account(Name='Test Account '+i));
        }
        insert accts;

        List<Contact> contacts = new List<Contact>();
        for(Integer i=0;i<5;i++){
            contacts.add(new Contact(FirstName='Contact'+i, LastName='Tester', AccountId=accts[i%accts.size()].Id, Email='test'+i+'@example.com'));
        }
        insert contacts;

        // Leads
        List<Lead> leads = new List<Lead>();
        for(Integer i=0;i<5;i++){
            leads.add(new Lead(FirstName='Lead'+i, LastName='Tester', Company='TestCo'));
        }
        insert leads;

        // Markets
        List<Market__c> markets = new List<Market__c>();
        for(Integer i=0;i<2;i++){
            markets.add(new Market__c(Name='Market '+i));
        }
        insert markets;

        // Reservations
        List<Reservation__c> reservs = new List<Reservation__c>();
        for(Integer i=0;i<12;i++){
            Reservation__c r = new Reservation__c(
                Name='Reservation '+i,
                Status__c = (i%2==0 ? 'Draft' : 'Not Started'),
                Start_Date__c = System.today(),
                End_Date__c = System.today().addDays(1),
                Total_Number_of_Guests__c = 2,
                Market__c = markets[0].Id
            );
            if(i%2==0) r.Contact__c = contacts[i%contacts.size()].Id;
            else r.Lead__c = leads[i%leads.size()].Id;
            reservs.add(r);
        }
        insert reservs;
    }

    // ----------------------------
    // Test for getCustomerList
    // ----------------------------
    @IsTest
    static void testGetCustomerList() {
        // Mock Customer_Fields__mdt inside test context
        Test.startTest();
        // Call for Contacts
        List<CustomerServices.Customer> contacts = ReservationManagerController.getCustomerList('Contact');
        System.assertNotEquals(contacts, null, 'Contacts list should not be null');
        System.assert(contacts.size() > 0, 'Should return at least one customer');

        // Call for Leads
        List<CustomerServices.Customer> leads = ReservationManagerController.getCustomerList('Lead');
        System.assertNotEquals(leads, null, 'Leads list should not be null');
        System.assert(leads.size() > 0, 'Should return at least one lead');

        System.assertNotEquals(contacts, leads, 'Contacts and Leads lists should not be equal');
        Test.stopTest();
    }

    // ----------------------------
    // Test for getOpenReservations
    // ----------------------------
    @IsTest
    static void testGetOpenReservations() {
        Test.startTest();
        List<Reservation__c> reservs = ReservationManagerController.getOpenReservations();
        System.assertNotEquals(reservs, null, 'Reservation list should not be null');
        System.assertEquals(reservs.size(), 10, 'Should return exactly 10 reservations due to LIMIT 10');
        for(Reservation__c r : reservs){
            System.assert(r.Status__c == 'Draft' || r.Status__c == 'Not Started', 'Status should be Draft or Not Started');
        }
        Test.stopTest();
    }
}
