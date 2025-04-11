/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TransporterService {
    @AuraEnabled(Cacheable=true)
    public static void assignBestTransporter(Order orderToValidate) {
        // Éviter les doublons
        List<Livraison__c> livraisonsExistantes = [
                SELECT Id FROM Livraison__c WHERE Commande__c = :orderToValidate.Id LIMIT 1
        ];

        if (!livraisonsExistantes.isEmpty()) {
            System.debug('❌ Livraison déjà existante pour cette commande. Pas de nouvelle création.');
            return;
        }

        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);
        List<Tarif__c> tarifs = TarifSelector.getTarifsByZoneName(acc.ShippingCountry, acc.Acc_TypeClient__c);

        if (tarifs == null || tarifs.isEmpty()) {
            System.debug('Aucun tarif trouvé pour ce compte.');
            return;
        }

        Tarif__c meilleurTarif = tarifs[0];

        Livraison__c livraison = new Livraison__c(
                Commande__c = orderToValidate.Id,
                Tarif__c = meilleurTarif.Id,
                Statut__c = 'En cours'
        );

        System.debug('🧪 assignBestTransporter lancé pour Order: ' + orderToValidate.Id);
        insert livraison;
    }
}

