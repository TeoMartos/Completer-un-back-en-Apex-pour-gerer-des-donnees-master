public with sharing class TransporterSelector {
    public static List<Transporteur__c> getTransporteurByTypeClient(String typeClient) {
        return [
                SELECT Id, Name, Type_Client__c
                FROM Transporteur__c
                WHERE Type_Client__c = :typeClient
        ];
    }
}