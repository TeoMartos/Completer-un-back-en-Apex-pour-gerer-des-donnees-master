/**
 * Created by TMARTOS on 27/03/2025.
 */

@IsTest
public class TransporterSelectorTest {

    @IsTest
    static void testGetTransporterById_Success() {
        // Création d’un transporteur de test
        Transporteur__c transporter = new Transporteur__c(
                Name = 'Test Transporteur',
                Type_Client__c = 'Professionnel',
                Zone_de_Livraison__c = 'France',
                Delais_de_Livraison__c = 2
        );
        insert transporter;

        // Appel de la méthode
        Transporteur__c result = TransporterSelector.getTransporterById(t.Id);

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
            System.assert(e.getMessage().contains('List has no rows'), 'Le message doit indiquer qu’aucune ligne n’a été trouvée');
        }
    }
}
