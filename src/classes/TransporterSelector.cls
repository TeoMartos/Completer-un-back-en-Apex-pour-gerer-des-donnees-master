public with sharing class TransporterSelector {
    public static Transporteur__c getTransporterById(Id transporterId) {
        return [
                SELECT Id, Name, Type_Client__c, Delais_de_Livraison__c, Zone_de_Livraison__c
                FROM Transporteur__c
                WHERE Id = :transporterId
        ];
    }
}