/**
 * Created by TMARTOS on 11/04/2025.
 */

public with sharing class LivraisonController {

    @AuraEnabled(Cacheable=true)
    public static Livraison__c getLivraisonById(Id livraisonId) {
        return LivraisonSelector.getLivraisonById(livraisonId);
    }

    @AuraEnabled(Cacheable=true)
    public static Livraison__c getLivraisonByOrderId(Id orderId) {
        return LivraisonSelector.getLivraisonByOrderId(orderId);
    }

    @AuraEnabled
    public static void updateTarifOnLivraison(Id livraisonId, Id newTarifId) {
        Livraison__c liv = LivraisonSelector.getLivraisonById(livraisonId);
        liv.Tarif__c = newTarifId;
        update liv;
    }
}