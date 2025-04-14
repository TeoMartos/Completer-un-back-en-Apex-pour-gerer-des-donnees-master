@IsTest
public class OrderControllerTest {

    @IsTest
    static void testGetOrderById() {
        Account acc = new Account(
                Name = 'Client Test',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        Order ord = new Order(
                Name = 'Commande Test',
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
        );
        insert ord;

        Test.startTest();
        Order result = OrderController.getOrderById(ord.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'La commande ne doit pas être null');
        System.assertEquals(ord.Id, result.Id, 'L\'ID doit correspondre');
    }

    @IsTest
    static void testValidateOrderControllerCall() {
        Account acc = new Account(
                Name = 'Client Pro',
                Acc_TypeClient__c = 'Professionnel',
                ShippingCountry = 'France'
        );
        insert acc;

        Id standardPbId = Test.getStandardPricebookId();

        // 🧾 Création d’une commande SANS Pricebook2Id pour l'instant
        Order ord = new Order(
                Name = 'Commande à valider',
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
        );
        insert ord;

        // 🛠️ MAJ manuelle du Pricebook2Id (car le Flow ne fonctionne pas toujours en test)
        ord.Pricebook2Id = standardPbId;
        update ord;

        Product2 prod = new Product2(
                Name = 'Produit test',
                IsActive = true,
                Categorie__c = 'Parfum'
        );
        insert prod;

        PricebookEntry standardEntry = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = standardPbId,
                UnitPrice = 10,
                IsActive = true
        );
        insert standardEntry;

        List<OrderItem> items = new List<OrderItem>();
        for (Integer i = 0; i < 5; i++) {
            items.add(new OrderItem(
                    OrderId = ord.Id,
                    Quantity = 1,
                    UnitPrice = 10,
                    PricebookEntryId = standardEntry.Id
            ));
        }
        insert items;

        Test.startTest();
        OrderController.validateOrder(ord);
        Test.stopTest();
    }
}
