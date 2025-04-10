@IsTest
private class TransporterServiceTest {

    @IsTest
    static void testAssignBestTransporter_createsLivraison() {
        // Activer le pricebook standard
        Id standardPbId = Test.getStandardPricebookId();
        update new Pricebook2(Id = standardPbId, IsActive = true);

        // 1. Créer un compte
        Account acc = new Account(
                Name = 'Client Test',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        // 2. Créer une zone de livraison
        Zone_de_Livraison__c zone = new Zone_de_Livraison__c(Name = 'France');
        insert zone;

        // 3. Créer un transporteur
        Transporteur__c transporteur = new Transporteur__c(
                Name = 'ChronoTest',
                TransporteurId__c = 1,
                Type_Client__c = 'Particulier'
        );
        insert transporteur;

        // 4. Créer un tarif
        Tarif__c tarif = new Tarif__c(
                Transporteur__c = transporteur.Id,
                Zone_de_Livraison__c = zone.Id,
                Tarif__c = 12.99,
                Delai_Livraison__c = 2
        );
        insert tarif;

        // 5. Créer une commande
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPbId
        );
        insert ord;

        // 6. Appeler le service à tester
        Test.startTest();
        TransporterService.assignBestTransporter(ord);
        Test.stopTest();

        // 7. Vérifier qu’une livraison a été créée et liée à la commande
        List<Livraison__c> livraisons = [
                SELECT Id, Commande__c, Tarif__c, Statut__c
                FROM Livraison__c
                WHERE Commande__c = :ord.Id
        ];

        System.assertEquals(1, livraisons.size(), 'Une livraison aurait dû être créée');
        System.assertEquals(tarif.Id, livraisons[0].Tarif__c, 'Le tarif assigné est incorrect');
    }
}
