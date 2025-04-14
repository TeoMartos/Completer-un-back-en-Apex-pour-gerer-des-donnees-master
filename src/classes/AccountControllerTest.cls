/**
 * Created by TMARTOS on 14/04/2025.
 */

@IsTest
public class AccountControllerTest {

    @IsTest
    static void testGetAccountById() {
        // Arrange : création d'un compte test
        Account acc = new Account(
                Name = 'Client Test Controller',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        // Act : appel via le controller
        Test.startTest();
        Account result = AccountController.getAccountById(acc.Id);
        Test.stopTest();

        // Assert : vérifications
        System.assertNotEquals(null, result, 'Le compte ne doit pas être null');
        System.assertEquals(acc.Id, result.Id, 'Les ID doivent correspondre');
        System.assertEquals('Particulier', result.Acc_TypeClient__c, 'Le type de client doit être "Particulier"');
        System.assertEquals('France', result.ShippingCountry, 'Le pays doit être France');
    }
}
