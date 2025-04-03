/**
 * Created by TMARTOS on 27/03/2025.
 */

@IsTest
public class TransporterSelectorTest {
    @TestSetup
    static void setupTestData() {
        // Créer des transporteurs pour différents types de clients
        List<Transporteur__c> transporteurs = new List<Transporteur__c>{
            new Transporteur__c(
                Name = 'Transporteur Pro',
                Type_Client__c = 'Professionnel'
            ),
            new Transporteur__c(
                Name = 'Transporteur Part',
                Type_Client__c = 'Particulier'
            ),
            new Transporteur__c(
                Name = 'Transporteur Les Deux',
                Type_Client__c = 'Les Deux'
            )
        };
        insert transporteurs;
    }

    @IsTest
    static void testGetTransporteurByTypeClient_Professionnel() {
        List<Transporteur__c> result = TransporterSelector.getTransporteurByTypeClient('Professionnel');
        
        System.assertEquals(1, result.size(), 'Un seul transporteur professionnel devrait être retourné');
        System.assertEquals('Professionnel', result[0].Type_Client__c, 'Le type de client devrait être Professionnel');
    }

    @IsTest
    static void testGetTransporteurByTypeClient_Particulier() {
        List<Transporteur__c> result = TransporterSelector.getTransporteurByTypeClient('Particulier');
        
        System.assertEquals(1, result.size(), 'Un seul transporteur particulier devrait être retourné');
        System.assertEquals('Particulier', result[0].Type_Client__c, 'Le type de client devrait être Particulier');
    }

    @IsTest
    static void testGetTransporteurByTypeClient_LesDeux() {
        List<Transporteur__c> result = TransporterSelector.getTransporteurByTypeClient('Les Deux');
        
        System.assertEquals(1, result.size(), 'Un seul transporteur "Les Deux" devrait être retourné');
        System.assertEquals('Les Deux', result[0].Type_Client__c, 'Le type de client devrait être Les Deux');
    }

    @IsTest
    static void testGetTransporteurByTypeClient_TypeInexistant() {
        List<Transporteur__c> result = TransporterSelector.getTransporteurByTypeClient('TypeInexistant');
        
        System.assertEquals(0, result.size(), 'Aucun transporteur ne devrait être retourné pour un type inexistant');
    }

/*
    @IsTest
    static void testGetTransporterById_Success() {
        // Création d'un transporteur de test
        Transporteur__c transporter = new Transporteur__c(
                Name = 'Test Transporteur',
                Type_Client__c = 'Professionnel'
        );
        insert transporter;

        // Appel de la méthode
        Transporteur__c result = TransporterSelector.getTransporteurByTypeClient(transporter.Id);

        // Vérifications
        System.assertNotEquals(null, result, 'Le transporteur ne doit pas être null');
        System.assertEquals(transporter.Id, result.Id, 'L\'ID doit correspondre');
        System.assertEquals('Professionnel', result.Type_Client__c);
    }

    @IsTest
    static void testGetTransporterById_Fail() {
        try {
            TransporterSelector.getTransporterById('a0B000000000000AAA'); // ID fictif
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Le message doit indiquer qu'aucune ligne n'a été trouvée');
        }
    }*/
}

