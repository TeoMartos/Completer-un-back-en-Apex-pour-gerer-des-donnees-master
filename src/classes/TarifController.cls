/**
 * Created by TMARTOS on 09/04/2025.
 */

public with sharing class TarifController {

    @AuraEnabled(Cacheable=true)
    public static List<Tarif__c> getTarifsByZoneName(String zoneName, String typeName) {
        return TarifSelector.getTarifsByZoneName(zoneName, typeName);
    }
}
