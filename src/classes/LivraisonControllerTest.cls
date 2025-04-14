/**
 * Created by TMARTOS on 14/04/2025.
 */

@IsTest
public class LivraisonControllerTest {

    @IsTest
    static void testLivraisonControllerMethods() {
        // Données de test : compte, commande, zone, transporteur, tarif, livraison
        Account acc = new Account(Name = 'Client Test', Acc_TypeClient__c = 'Particulier', ShippingCountry = 'France');
        insert acc;

        Order ord = new Order(
                Name = 'Commande Test',
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today()
        );
        insert ord;

        Zone_de_Livraison__c zone = new Zone_de_Livraison__c(Name = 'France');
        insert zone;

        Transporteur__c transporteur = new Transporteur__c(Name = 'Transporteur A', Type_Client__c = 'Particulier');
        insert transporteur;

        Tarif__c tarif = new Tarif__c(
                Tarif__c = 9.99,
                Delai_Livraison__c = 3,
                Transporteur__c = transporteur.Id,
                Zone_de_Livraison__c = zone.Id
        );
        insert tarif;

        Livraison__c livraison = new Livraison__c(
                Commande__c = ord.Id,
                Statut__c = 'En cours'
        );
        insert livraison;

        // Appels à tester
        Test.startTest();
        Livraison__c livById = LivraisonController.getLivraisonById(livraison.Id);
        Livraison__c livByOrder = LivraisonController.getLivraisonByOrderId(ord.Id);
        LivraisonController.updateTarifOnLivraison(livraison.Id, tarif.Id);
        Test.stopTest();

        // Assertions
        System.assertEquals(livraison.Id, livById.Id, 'L\'ID de la livraison doit correspondre.');
        System.assertEquals(livraison.Id, livByOrder.Id, 'La livraison doit correspondre à la commande.');

        Livraison__c updatedLivraison = [SELECT Tarif__c FROM Livraison__c WHERE Id = :livraison.Id];
        System.assertEquals(tarif.Id, updatedLivraison.Tarif__c, 'Le tarif doit avoir été mis à jour correctement.');
    }
}

