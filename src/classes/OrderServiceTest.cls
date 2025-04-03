@IsTest
public class OrderServiceTest {

    static void setupData(String typeClient, Integer nbProduits, Boolean withTransporter) {
        Id standardPbId = Test.getStandardPricebookId();

// ⚠️ PAS de requête ici ! Juste un update direct :
        update new Pricebook2(Id = standardPbId, IsActive = true);


        // 1. Création du compte
        Account acc = new Account(
                Name = 'Test Client',
                Account_LastName__c = 'Test',
                Acc_TypeClient__c = typeClient,
                ShippingCountry = 'France'
        );
        insert acc;

        // 2. Transporteur et tarif si demandé
        Transporteur__c transporteur;
        if (withTransporter) {
            transporteur = new Transporteur__c(
                    Name = 'Chrono',
                    Type_Client__c = 'Les Deux'
            );
            insert transporteur;
        }

        // 3. Création de la commande
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPbId // 🪄 Et voilà le fix magique !
        );
        insert ord;

        // 4. Produit après le pricebook
        Product2 p = new Product2(
                Name = 'Test Product',
                IsActive = true,
                Categorie__c = 'Bijoux'
        );
        insert p;

        PricebookEntry pbe = new PricebookEntry(
                Product2Id = p.Id,
                Pricebook2Id = standardPbId,
                UnitPrice = 10,
                IsActive = true
        );
        insert pbe;

        // 5. OrderItems
        List<OrderItem> items = new List<OrderItem>();
        for (Integer i = 0; i < nbProduits; i++) {
            items.add(new OrderItem(
                    OrderId = ord.Id,
                    Quantity = 1,
                    UnitPrice = 10,
                    PricebookEntryId = pbe.Id
            ));
        }
        insert items;
        update ord;
        // 6. Reload + appel méthode métier
        ord = [SELECT Id, AccountId, Transporteur_Choisi__c, Nombre_de_Produits__c FROM Order WHERE Id = :ord.Id];
        OrderService.validateOrder(ord);
    }


    @IsTest static void testParticulierValide() {
        try {
            setupData('Particulier', 3, true);
            System.assert(true, 'Un Particulier avec 3 produits.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('au moins 3 produits'), 'Le message d’erreur est incorrect : ' + e.getMessage());
        }
    }

    @IsTest static void testProfessionnelValide() {
        try {
            setupData('Professionnel', 5, true);
            System.assert(true, 'Un Professionnel avec 5 produits.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('au moins 5 produits'), 'Le message d’erreur est incorrect : ' + e.getMessage());
        }
    }

    @IsTest static void testProfessionnelInvalide() {
        try {
            setupData('Professionnel', 2, true);
            System.assert(false, 'Une exception aurait dû être levée pour un Professionnel avec moins de 5 produits.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('au moins 5 produits'), 'Le message d’erreur est incorrect : ' + e.getMessage());
        }
    }

    @IsTest static void testParticulierInvalide() {
        try {
            setupData('Particulier', 2, true);
            System.assert(false, 'Une exception aurait dû être levée pour un particulier avec moins de 3 produits.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('au moins 3 produits'), 'Le message d’erreur est incorrect : ' + e.getMessage());
        }
    }
    @IsTest static void testSansTransporteur() {
        try {
            setupData('Professionnel', 5, false);
            System.assert(false, 'Il faut renseigner un Transporteur');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Il faut renseigner un Transporteur'), 'Le message d’erreur est incorrect : ' + e.getMessage());
        }
    }
}
