@IsTest
public class OrderTriggerTest {
    @IsTest
    static void setupTestData() {
        // Créer un compte particulier
        Account compteParticulier = new Account(
            Name = 'Test Particulier',
            Acc_TypeClient__c = 'Particulier'
        );
        insert compteParticulier;
        
        // Créer un compte professionnel
        Account comptePro = new Account(
            Name = 'Test Professionnel',
            Acc_TypeClient__c = 'Professionnel'
        );
        insert comptePro;
    }
    
    @isTest
    static void testParticulierMoinsDe3Produits() {
        // Récupérer le compte particulier
        Account compteParticulier = [SELECT Id FROM Account WHERE Acc_TypeClient__c = 'Particulier' LIMIT 1];
        
        // Créer une commande avec moins de 3 produits
        Order commande = new Order(
            AccountId = compteParticulier.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Order_NombreProduits__c = 2
        );
        
        // Tester l'insertion
        Test.startTest();
        try {
            insert commande;
            System.assert(false, 'Une erreur aurait dû être levée');
        } catch(DmlException e) {
            System.assertEquals('Le nombre minimum de produits pour un particulier est de 3', e.getDmlMessage(0));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testParticulierPlusDe3Produits() {
        // Récupérer le compte particulier
        Account compteParticulier = [SELECT Id FROM Account WHERE Acc_TypeClient__c = 'Particulier' LIMIT 1];
        
        // Créer une commande avec plus de 3 produits
        Order commande = new Order(
            AccountId = compteParticulier.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Order_NombreProduits__c = 4
        );
        
        // Tester l'insertion
        Test.startTest();
        insert commande;
        Test.stopTest();
        
        // Vérifier que la commande a été créée
        Order commandeCreee = [SELECT Id FROM Order WHERE Id = :commande.Id];
        System.assertNotEquals(null, commandeCreee.Id, 'La commande devrait avoir été créée');
    }
    
    @isTest
    static void testProfessionnelMoinsDe5Produits() {
        // Récupérer le compte professionnel
        Account comptePro = [SELECT Id FROM Account WHERE Acc_TypeClient__c = 'Professionnel' LIMIT 1];
        
        // Créer une commande avec moins de 5 produits
        Order commande = new Order(
            AccountId = comptePro.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Order_NombreProduits__c = 3
        );
        
        // Tester l'insertion
        Test.startTest();
        try {
            insert commande;
            System.assert(false, 'Une erreur aurait dû être levée');
        } catch(DmlException e) {
            System.assertEquals('Le nombre minimum de produits pour un professionnel est de 5', e.getDmlMessage(0));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testProfessionnelPlusDe5Produits() {
        // Récupérer le compte professionnel
        Account comptePro = [SELECT Id FROM Account WHERE Acc_TypeClient__c = 'Professionnel' LIMIT 1];
        
        // Créer une commande avec plus de 5 produits
        Order commande = new Order(
            AccountId = comptePro.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Order_NombreProduits__c = 6
        );
        
        // Tester l'insertion
        Test.startTest();
        insert commande;
        Test.stopTest();
        
        // Vérifier que la commande a été créée
        Order commandeCreee = [SELECT Id FROM Order WHERE Id = :commande.Id];
        System.assertNotEquals(null, commandeCreee.Id, 'La commande devrait avoir été créée');
    }
} 