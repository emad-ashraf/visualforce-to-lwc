@IsTest
public class ReservationManagerControllerSimpleTest {

    @TestSetup
    static void setup() {
        // Create 2 Markets
        List<Market__c> markets = new List<Market__c>();
        for(Integer i=0;i<2;i++){
            markets.add(new Market__c(Name='Market '+i));
        }
        insert markets;

        // Create 5 Contacts
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0;i<5;i++){
            contacts.add(new Contact(FirstName='Contact'+i, LastName='Tester', Email='contact'+i+'@example.com'));
        }
        insert contacts;

        // Create 12 Reservations with Status = Draft or Not Started
        List<Reservation__c> reservs = new List<Reservation__c>();
        for(Integer i=0;i<12;i++){
            Reservation__c r = new Reservation__c(
                Name='Reservation '+i,
                Status__c = (i%2==0 ? 'Draft' : 'Not Started'),
                Start_Date__c = System.today(),
                End_Date__c = System.today().addDays(1),
                Total_Number_of_Guests__c = 2,
                Market__c = markets[0].Id,
                Contact__c = contacts[i%contacts.size()].Id
            );
            reservs.add(r);
        }
        insert reservs;
    }

    @IsTest
    static void testGetOpenReservations() {
        List<Reservation__c> reservations = ReservationManagerController.getOpenReservations();
        System.assertNotEquals(reservations, null, 'Reservations list should not be null');
        System.assertEquals(reservations.size(), 10, 'Should return exactly 10 reservations due to LIMIT 10');

        for(Reservation__c r : reservations) {
            System.assert(r.Status__c == 'Draft' || r.Status__c == 'Not Started', 'Status should be Draft or Not Started');
            System.assert(r.Market__c != null, 'Market should be set');
            System.assert(r.Contact__c != null, 'Contact should be set');
        }
    }
}
