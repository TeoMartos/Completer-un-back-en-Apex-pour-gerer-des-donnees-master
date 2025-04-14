public with sharing class OrderService {
    @AuraEnabled(Cacheable=true)
    public static void validateOrder(Order orderToValidate) {
        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);

        Integer minProduitsPro = 5;
        Integer minProduitsParticulier = 3;
        Integer minProduits;

        if (acc.Acc_TypeClient__c == 'Professionnel') {
            minProduits = minProduitsPro;
        } else {
            minProduits = minProduitsParticulier;
        }

        // 🔍 Ajout du log debug
        OrderSelector.logOrderDetails(orderToValidate.Id);

        if (orderToValidate.Nombre_Produits__c < minProduits) {
            orderToValidate.addError(
                    'Le client de type ' + acc.Acc_TypeClient__c + ' doit commander au moins ' + minProduits + ' produits.'
            );
        }
    }
}
