/**
 * Created by TMARTOS on 03/04/2025.
 */

@IsTest
private class TarifSelectorTest {
    @TestSetup
    static void setupTestData() {
        // Créer une zone de livraison
        Zone_de_Livraison__c zone = new Zone_de_Livraison__c(
            Name = 'France'
        );
        insert zone;
        
        // Créer un transporteur pour particulier
        Transporteur__c transporteurParticulier = new Transporteur__c(
            Name = 'Transporteur Particulier',
            Type_Client__c = 'Particulier'
        );
        insert transporteurParticulier;
        
        // Créer un transporteur pour professionnel
        Transporteur__c transporteurPro = new Transporteur__c(
            Name = 'Transporteur Pro',
            Type_Client__c = 'Professionnel'
        );
        insert transporteurPro;
        
        // Créer des tarifs pour le transporteur particulier
        Tarif__c tarif1 = new Tarif__c(
            Zone_de_Livraison__c = zone.Id,
            Transporteur__c = transporteurParticulier.Id,
            Tarif__c = 10,
            Delai_Livraison__c = 2
        );
        
        Tarif__c tarif2 = new Tarif__c(
            Zone_de_Livraison__c = zone.Id,
            Transporteur__c = transporteurParticulier.Id,
            Tarif__c = 15,
            Delai_Livraison__c = 1
        );
        
        // Créer un tarif pour le transporteur professionnel
        Tarif__c tarif3 = new Tarif__c(
            Zone_de_Livraison__c = zone.Id,
            Transporteur__c = transporteurPro.Id,
            Tarif__c = 20,
            Delai_Livraison__c = 3
        );
        
        insert new List<Tarif__c>{tarif1, tarif2, tarif3};
    }
    
    @IsTest
    static void testBehavior() {
        // Tester la récupération des tarifs pour un particulier
        List<Tarif__c> tarifsParticulier = TarifSelector.getTarifsByZoneName('France', 'Particulier');
        System.assertEquals(2, tarifsParticulier.size(), 'Deux tarifs devraient être retournés pour un particulier');
        System.assertEquals(10, tarifsParticulier[0].Tarif__c, 'Le premier tarif devrait être le moins cher');
        System.assertEquals(15, tarifsParticulier[1].Tarif__c, 'Le deuxième tarif devrait être le plus cher');
        
        // Tester la récupération des tarifs pour un professionnel
        List<Tarif__c> tarifsPro = TarifSelector.getTarifsByZoneName('France', 'Professionnel');
        System.assertEquals(1, tarifsPro.size(), 'Un seul tarif devrait être retourné pour un professionnel');
        System.assertEquals(20, tarifsPro[0].Tarif__c, 'Le tarif devrait être celui du transporteur professionnel');
        
        // Tester la récupération des tarifs pour une zone inexistante
        List<Tarif__c> tarifsInexistants = TarifSelector.getTarifsByZoneName('ZoneInexistante', 'Particulier');
        System.assertEquals(0, tarifsInexistants.size(), 'Aucun tarif ne devrait être retourné pour une zone inexistante');
    }
}