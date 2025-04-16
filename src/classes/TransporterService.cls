/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TransporterService {
    @AuraEnabled(Cacheable=true)
    public static void assignBestTransporter(Order orderToValidate) {
        List<Livraison__c> livraisonsExistantes = [
                SELECT Id FROM Livraison__c WHERE Commande__c = :orderToValidate.Id LIMIT 1
        ];

        if (!livraisonsExistantes.isEmpty()) {
            return;
        }

        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);
        List<Tarif__c> tarifs = TarifSelector.getTarifsByZoneName(acc.ShippingCountry, acc.Acc_TypeClient__c);

        if (tarifs == null || tarifs.isEmpty()) {
            return;
        }

        Tarif__c meilleurTarif = tarifs[0];

        Livraison__c livraison = new Livraison__c(
                Commande__c = orderToValidate.Id,
                Tarif__c = meilleurTarif.Id,
                Statut__c = 'En cours'
        );
        insert livraison;
    }
}

