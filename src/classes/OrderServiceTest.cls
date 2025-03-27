@IsTest
public class OrderServiceTest {

    static void setupData(String typeClient, Integer nbProduits, Boolean withTransporter) {
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
                    Type_Client__c = 'Les Deux',
                    Zone_de_Livraison__c = 'France',
                    Delais_de_Livraison__c = 2
            );
            insert transporteur;

            Tarif_Transport__c tarif = new Tarif_Transport__c(
                    Transporteur__c = transporteur.Id,
                    Pays_Livraison__c = 'France',
                    Tarif__c = 10,
                    Delai_Livraison__c = 2
            );
            insert tarif;
        }

        // 3. Création de la commande (sans Order_NombreProduits__c car c’est un roll-up)
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today() // requis pour insérer une commande
        );
        insert ord;

// 4. Ajout de produits réels à la commande (simulateur du roll-up)
        Product2 p = new Product2(Name = 'Test Product', IsActive = true);
        insert p;

        Pricebook2 stdPb = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = p.Id,
                Pricebook2Id = stdPb.Id,
                UnitPrice = 10,
                IsActive = true
        );
        insert pbe;

// Création des OrderItem pour simuler le nombre de produits
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

// 5. Recharger la commande (le roll-up est maintenant actif)
        ord = [SELECT Id, AccountId, Order_NombreProduits__c, Transporteur_Choisi__c FROM Order WHERE Id = :ord.Id];

// 6. Appel à la méthode de validation
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
