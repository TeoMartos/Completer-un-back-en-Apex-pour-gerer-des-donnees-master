/**
 * Created by TMARTOS on 09/04/2025.
 */

public with sharing class TarifController {
    @AuraEnabled
    public static void updateTarifOnLivraison(Id livraisonId, Id newTarifId) {
        Livraison__c liv = [
                SELECT Id
                FROM Livraison__c
                WHERE Id = :livraisonId
                LIMIT 1
        ];
        liv.Tarif__c = newTarifId;
        update liv;
    }

    @AuraEnabled(Cacheable=true)
    public static Livraison__c getLivraisonByOrderId(Id orderId) {
        return [
                SELECT Id,
                        Tarif__r.Tarif__c,
                        Tarif__r.Delai_Livraison__c,
                        Tarif__r.Transporteur__r.Name,
                        Tarif__r.Zone_de_Livraison__r.Name
                FROM Livraison__c
                WHERE Commande__c = :orderId
                LIMIT 1
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static Livraison__c getLivraisonById(Id livraisonId) {
        return [
                SELECT Id,
                        Commande__c,
                        Commande__r.AccountId
                FROM Livraison__c
                WHERE Id = :livraisonId
                LIMIT 1
        ];
    }


}
