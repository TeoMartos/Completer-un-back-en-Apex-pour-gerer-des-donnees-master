trigger OrderTrigger on Order (before insert, before update) {

    // Création
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Order ord : Trigger.new) {
            OrderService.validateOrder(ord);

            if (ord.Order_StatutCommande__c == 'Confirmée') {
                TransporterService.assignBestTransporter(ord);
            }
        }
    }

    // Mise à jour
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order ord : Trigger.new) {
            Order oldOrd = Trigger.oldMap.get(ord.Id);

            OrderService.validateOrder(ord);

            if (ord.Order_StatutCommande__c == 'Confirmée' &&
                    oldOrd.Order_StatutCommande__c != 'Confirmée') {
                TransporterService.assignBestTransporter(ord);
            }
        }
    }
}
