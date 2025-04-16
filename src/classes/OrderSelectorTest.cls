@IsTest
public class OrderSelectorTest {

    @IsTest
    static void testGetOrderById_Success() {
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

        Test.startTest();
        Order result = OrderSelector.getOrderById(ord.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'La commande ne doit pas être null');
        System.assertEquals(ord.Id, result.Id, 'L\'ID de la commande doit correspondre');
    }

    @IsTest
    static void testGetOrderById_Fail() {
        try {
            OrderSelector.getOrderById('801000000000000AAA'); // ID bidon
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(true, 'Exception correctement levée.');
        }
    }

    @IsTest
    static void testLogOrderDetails() {
        Account acc = new Account(
                Name = 'Client Log',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        Id standardPbId = Test.getStandardPricebookId();

        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
        );
        insert ord;

        // Important : assigner le Pricebook2Id après insert (Flow trigger empêche la valeur de persister si mise avant)
        ord.Pricebook2Id = standardPbId;
        update ord;

        Product2 prod = new Product2(Name = 'Produit test', IsActive = true, Categorie__c = 'Parfum');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = standardPbId,
                UnitPrice = 20,
                IsActive = true
        );
        insert pbe;

        OrderItem item1 = new OrderItem(
                OrderId = ord.Id,
                Quantity = 2,
                UnitPrice = 20,
                PricebookEntryId = pbe.Id
        );
        insert item1;

        Test.startTest();
        OrderSelector.logOrderDetails(ord.Id);
        Test.stopTest();
    }
}
