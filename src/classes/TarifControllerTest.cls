/**
 * Created by TMARTOS on 14/04/2025.
 */

@IsTest
private class TarifControllerTest {

    @TestSetup
    static void setupData() {
        Zone_de_Livraison__c zone = new Zone_de_Livraison__c(Name = 'France');
        insert zone;

        Transporteur__c transporteur = new Transporteur__c(Name = 'ChronoTest', Type_Client__c = 'Particulier');
        insert transporteur;

        insert new List<Tarif__c>{
                new Tarif__c(Zone_de_Livraison__c = zone.Id, Transporteur__c = transporteur.Id, Tarif__c = 5, Delai_Livraison__c = 1),
                new Tarif__c(Zone_de_Livraison__c = zone.Id, Transporteur__c = transporteur.Id, Tarif__c = 9, Delai_Livraison__c = 2)
        };
    }

    @IsTest
    static void testGetTarifsByZoneNameViaController() {
        Test.startTest();
        List<Tarif__c> result = TarifController.getTarifsByZoneName('France', 'Particulier');
        Test.stopTest();

        System.assertEquals(2, result.size(), 'Le contrôleur doit retourner 2 tarifs pour France / Particulier');
        System.assert(result[0].Tarif__c <= result[1].Tarif__c, 'Les tarifs doivent être triés par prix croissant');
    }

    @IsTest
    static void testGetTarifsByZoneName_EmptyResult() {
        List<Tarif__c> result = TarifController.getTarifsByZoneName('Espagne', 'Particulier');
        System.assertEquals(0, result.size(), 'Aucun tarif ne doit être retourné pour une zone inexistante');
    }
}
