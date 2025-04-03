/**
 * Created by TMARTOS on 03/04/2025.
 */

public with sharing class TransporterService {
    public static void assignBestTransporter(Order orderToValidate) {
        Account acc = AccountSelector.getAccountById(orderToValidate.AccountId);
        List<Transporteur__c> transporteurs = TransporterSelector.getTransporteurByTypeClient(acc.Acc_TypeClient__c);
        List<Tarif__c> tarifs = TarifSelector.getTarifsByZoneName(acc.ShippingCountry);
    }
}