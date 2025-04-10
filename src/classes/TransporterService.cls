/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TransporterService {
    @AuraEnabled(Cacheable=true)
    public static void assignBestTransporter(Order orderToValidate) {
        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);
        List<Tarif__c> tarifs = TarifSelector.getTarifsByZoneName(acc.ShippingCountry, acc.Acc_TypeClient__c);

        if (tarifs == null || tarifs.isEmpty()) {
            System.debug('Aucun tarif trouvé pour ce compte.');
            return;
        }

        // On sélectionne le tarif le plus avantageux (déjà trié dans la requête)
        Tarif__c meilleurTarif = tarifs[0];

        // Création de la livraison
        Livraison__c livraison = new Livraison__c(
                Commande__c = orderToValidate.Id,
                Tarif__c = meilleurTarif.Id,
                Statut__c = 'En cours'
        );
        insert livraison;
    }
}
