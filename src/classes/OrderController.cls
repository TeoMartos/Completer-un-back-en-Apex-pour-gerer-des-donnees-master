/**
 * Created by TMARTOS on 11/04/2025.
 */

public with sharing class OrderController {

    @AuraEnabled(Cacheable=true)
    public static Order getOrderById(Id orderId) {
        return OrderSelector.getOrderById(orderId);
    }

    @AuraEnabled(Cacheable=true)
    public static void validateOrder(Order orderToValidate) {
        OrderService.validateOrder(orderToValidate);
    }
}
