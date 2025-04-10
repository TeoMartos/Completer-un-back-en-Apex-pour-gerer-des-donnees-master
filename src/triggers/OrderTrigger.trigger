trigger OrderTrigger on Order (before update) {
    for (Order ord : Trigger.new) {
        Order oldOrd = Trigger.oldMap.get(ord.Id);

        OrderService.validateOrder(ord);

        if (ord.Order_StatutCommande__c == 'Confirmée' && oldOrd.Order_StatutCommande__c != 'Confirmée') {
            TransporterService.assignBestTransporter(ord);
        }
    }
}
