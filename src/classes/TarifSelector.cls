/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TarifSelector {
    public static List<Tarif__c> getTarifsByZoneName(String zoneName) {
        return [
                SELECT Id, Zone_de_Livraison__r.Name, Transporteur__r.Name, Tarif__c, Delai_Livraison__c
                FROM Tarif__c
                WHERE Zone_de_Livraison__r.Name = :zoneName
                ORDER BY Tarif__c ASC, Delai_Livraison__c ASC
        ];
    }
}
