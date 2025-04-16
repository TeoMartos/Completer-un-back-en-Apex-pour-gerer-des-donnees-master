@IsTest
public class OrderServiceTest {

    static void setupData(String typeClient, Integer nbProduits, Boolean withTransporter) {
        Id standardPbId = Test.getStandardPricebookId();
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
        if (withTransporter) {
            Transporteur__c transporteur = new Transporteur__c(
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
                Pricebook2Id = standardPbId
        );
        insert ord;

        // 🚨 Correction ici : réassigner Pricebook après le flow Order_AfterInsert_PriceBook
        ord.Pricebook2Id = standardPbId;
        update ord;

        // 4. Produit et PricebookEntry
        Product2 p = new Product2(Name = 'Test Product', IsActive = true, Categorie__c = 'Bijoux');
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

        // 6. Reload + appel
        ord = [SELECT Id, AccountId, Nombre_Produits__c FROM Order WHERE Id = :ord.Id];
        OrderService.validateOrder(ord);
    }

    @IsTest static void testParticulierValide() {
        try {
            setupData('Particulier', 3, true);
            System.assert(true, 'Un Particulier avec 3 produits.');
        } catch (DmlException e) {
            System.assert(false, 'Erreur inattendue : ' + e.getMessage());
        }
    }

    @IsTest static void testProfessionnelValide() {
        try {
            setupData('Professionnel', 5, true);
            System.assert(true, 'Un Professionnel avec 5 produits.');
        } catch (DmlException e) {
            System.assert(false, 'Erreur inattendue : ' + e.getMessage());
        }
    }

    @IsTest static void testProfessionnelInvalide() {
        try {
            setupData('Professionnel', 2, true);
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (DmlException e) {
            System.assert(true, 'Exception correctement levée');
        }
    }

    @IsTest static void testParticulierInvalide() {
        try {
            setupData('Particulier', 2, true);
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (DmlException e) {
            System.assert(true, 'Exception correctement levée');
        }
    }

    @IsTest static void testSansTransporteur() {
        try {
            setupData('Professionnel', 5, false);
            System.assert(true, 'Un professionnel peut passer sans transporteur dans ce contexte de test');
        } catch (Exception e) {
            System.assert(false, 'Erreur inattendue : ' + e.getMessage());
        }
    }

    @IsTest static void testSansTypeClient() {
        try {
            Account acc = new Account(Name = 'Client Sans Type', ShippingCountry = 'France');
            insert acc;
            System.assert(false, 'Une exception aurait dû être levée pour type client manquant');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('type de client'), 'Le message doit parler du type de client');
        }
    }

    @IsTest static void testSansNombreProduits() {
        Account acc = new Account(
                Name = 'Client Test Null',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        Id standardPbId = Test.getStandardPricebookId();
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPbId
        );
        insert ord;

        // 🚨 Même correction ici : s'assurer que le Pricebook est bien affecté
        ord.Pricebook2Id = standardPbId;
        update ord;

        // Pas d'OrderItem → Nombre_Produits__c null
        try {
            OrderService.validateOrder(ord);
            System.assert(true, 'Doit passer même si le champ est null (grâce à < opérateur)');
        } catch (Exception e) {
            System.assert(false, 'Erreur inattendue : ' + e.getMessage());
        }
    }
}
