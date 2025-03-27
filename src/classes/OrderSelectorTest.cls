/**
 * Created by TMARTOS on 27/03/2025.
 */

@IsTest
public class OrderSelectorTest {

    @IsTest
    static void testGetOrderById_Success() {
        // Setup : créer un client et une commande minimale
        Account acc = new Account(
                Name = 'Client Test',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
        );
        insert ord;

        // Appel de la méthode
        Order result = OrderSelector.getOrderById(ord.Id);

        // Vérifications
        System.assertNotEquals(null, result, 'La commande ne doit pas être null');
        System.assertEquals(ord.Id, result.Id, 'L\'ID de la commande doit correspondre');
    }

    @IsTest
    static void testGetOrderById_Fail() {
        try {
            OrderSelector.getOrderById('801000000000000AAA'); // ID fictif
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Message attendu : aucune ligne trouvée');
        }
    }
}
