/**
 * Created by TMARTOS on 11/04/2025.
 */

public with sharing class LivraisonSelector {

    public static Livraison__c getLivraisonById(Id livraisonId) {
        List<Livraison__c> results = [
                SELECT Id,
                        Commande__c,
                        Commande__r.AccountId
                FROM Livraison__c
                WHERE Id = :livraisonId
                LIMIT 1
        ];

        if (results.isEmpty()) {
            throw new AuraHandledException('Aucune livraison trouvée pour cet ID.');
        }

        return results[0];
    }

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

    public static List<Livraison__c> getLivraisonsByOrderId(Id orderId) {
        return [
                SELECT Id
                FROM Livraison__c
                WHERE Commande__c = :orderId
        ];
    }
}
