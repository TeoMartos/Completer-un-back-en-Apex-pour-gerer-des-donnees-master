/**
 * Created by TMARTOS on 14/04/2025.
 */

@IsTest
public class LivraisonSelectorTest {

    @IsTest
    static void testGetLivraisonByIdAndOrderId() {
        // Données de test
        Account acc = new Account(Name = 'Compte Test', Acc_TypeClient__c = 'Particulier', ShippingCountry = 'France');
        insert acc;

        Order ord = new Order(Name = 'Commande Test', AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.newInstance(2025, 1, 1));
        insert ord;

        Livraison__c liv = new Livraison__c(Commande__c = ord.Id, Statut__c = 'En cours');
        insert liv;

        // Test : getLivraisonById
        Test.startTest();
        Livraison__c result = LivraisonSelector.getLivraisonById(liv.Id);
        Test.stopTest();
        System.assertEquals(liv.Id, result.Id, 'L\'ID de la livraison doit correspondre.');
    }

    @IsTest
    static void testGetLivraisonByOrderId() {
        // Données de test
        Account acc = new Account(Name = 'Compte Test', Acc_TypeClient__c = 'Professionnel', ShippingCountry = 'Belgique');
        insert acc;

        Order ord = new Order(Name = 'Commande Pro', AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.newInstance(2025, 1, 1));
        insert ord;

        Livraison__c liv = new Livraison__c(Commande__c = ord.Id, Statut__c = 'En cours');
        insert liv;

        Livraison__c result = LivraisonSelector.getLivraisonByOrderId(ord.Id);
        System.assertEquals(liv.Id, result.Id, 'La livraison retournée doit correspondre à la commande.');
    }

    @IsTest
    static void testGetLivraisonsByOrderId_List() {
        // Données de test
        Account acc = new Account(Name = 'Compte Test Liste', Acc_TypeClient__c = 'Particulier', ShippingCountry = 'France');
        insert acc;

        Order ord = new Order(Name = 'Commande Liste', AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.newInstance(2025, 1, 1));
        insert ord;

        Livraison__c liv1 = new Livraison__c(Commande__c = ord.Id, Statut__c = 'En cours');
        Livraison__c liv2 = new Livraison__c(Commande__c = ord.Id, Statut__c = 'Livrée');
        insert new List<Livraison__c>{liv1, liv2};

        List<Livraison__c> results = LivraisonSelector.getLivraisonsByOrderId(ord.Id);
        System.assertEquals(2, results.size(), 'Il doit y avoir deux livraisons pour cette commande.');
    }

    @IsTest
    static void testGetLivraisonById_NotFound() {
        try {
            LivraisonSelector.getLivraisonById('a0B000000000000AAA');
            System.assert(false, 'Une exception aurait dû être levée.');
        } catch (AuraHandledException e) {
            System.assert(true, 'Exception correctement levée.');
        }
    }
}