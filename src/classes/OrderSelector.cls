/**
 * Created by TMARTOS on 26/03/2025.
 */

public with sharing class OrderSelector {
    public static Order getOrderById(Id orderId) {
        return [
                SELECT Id, Name, Pays_Livraison__c, Order_NombreProduits__c, Transporteur_Choisi__c, Transporteur_Choisi__r.Name
                FROM Order
                WHERE Id = :orderId
        ];
    }
}