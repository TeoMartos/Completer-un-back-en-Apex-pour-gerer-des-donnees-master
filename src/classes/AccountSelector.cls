public with sharing class AccountSelector {
    @AuraEnabled(Cacheable=true)
    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Acc_TypeClient__c, ShippingCountry
                FROM Account
                WHERE Id = :accountId
        ];
    }
}