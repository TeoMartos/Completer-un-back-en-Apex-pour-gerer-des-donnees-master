@IsTest
public class AccountSelectorTest {

    @IsTest
    static void testGetAccountById_Success() {
        // Création d’un compte de test
        Account acc = new Account(
                Name = 'Client Test',
                Account_LastName__c = 'Test',
                Acc_TypeClient__c = 'Particulier',
                ShippingCountry = 'France'
        );
        insert acc;

        // Appel de la méthode
        Account result = AccountSelector.getAccountById(acc.Id);

        // Vérification
        System.assertNotEquals(null, result, 'Le compte ne doit pas être null');
        System.assertEquals(acc.Id, result.Id, 'L\'ID doit correspondre');
        System.assertEquals('Particulier', result.Acc_TypeClient__c, 'Le type doit être Particulier');
    }

    @IsTest
    static void testGetAccountById_Fail() {
        // Tentative de récupération d’un compte inexistant
        try {
            AccountSelector.getAccountById('001000000000000AAA'); // ID bidon
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Le message doit indiquer qu’aucune ligne n\'a été trouvée');
        }
    }
}
