public with sharing class TransporterSelector {
    public static Transporteur__c getTransporterById(Id transporterId) {
        return [
                SELECT Id, Name, Type_Client__c
                FROM Transporteur__c
                WHERE Id = :transporterId
        ];
    }
}