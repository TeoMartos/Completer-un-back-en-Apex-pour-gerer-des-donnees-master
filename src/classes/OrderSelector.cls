/**
 * Created by TMARTOS on 26/03/2025.
 */

public with sharing class OrderSelector {

    @AuraEnabled(Cacheable=true)
    public static Order getOrderById(Id orderId) {
        List<Order> results = [
                SELECT Id, AccountId, Name, Pays_Liv_Acc__c, Nombre_Produits__c
                FROM Order
                WHERE Id = :orderId
                LIMIT 1
        ];
        if (results.isEmpty()) {
            throw new AuraHandledException('Commande introuvable pour l\'ID fourni.');
        }
        return results[0];
    }

    public static void logOrderDetails(Id orderId) {
        List<OrderItem> items = [
                SELECT Quantity, Product2.Name
                FROM OrderItem
                WHERE OrderId = :orderId
        ];

        Integer totalQuantite = 0;
        for (OrderItem item : items) {
            if (item.Quantity != null) {
                totalQuantite += Integer.valueOf(item.Quantity);
            }
        }
    }
}
