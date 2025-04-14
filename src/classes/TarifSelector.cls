/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TarifSelector {
    @AuraEnabled(Cacheable=true)
    public static List<Tarif__c> getTarifsByZoneName(String zoneName, String typeName) {
        return [
                SELECT Id,
                        Tarif__c,
                        Delai_Livraison__c,
                        Transporteur__r.Name,
                        Zone_de_Livraison__r.Name
                FROM Tarif__c
                WHERE Zone_de_Livraison__r.Name = :zoneName
                AND Transporteur__r.Type_Client__c = :typeName
                ORDER BY Tarif__c ASC, Delai_Livraison__c ASC
        ];
    }
}