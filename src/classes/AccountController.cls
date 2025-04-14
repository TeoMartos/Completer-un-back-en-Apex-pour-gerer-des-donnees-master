/**
 * Created by TMARTOS on 11/04/2025.
 */

public with sharing class AccountController {
    @AuraEnabled(Cacheable=true)
    public static Account getAccountById(Id accountId) {
        return AccountSelector.getAccountById(accountId);
    }
}