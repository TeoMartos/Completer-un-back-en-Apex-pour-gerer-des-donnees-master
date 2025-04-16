trigger OrderTrigger on Order (before insert, before update, after update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order ord : Trigger.new) {
            if (ord.Order_StatutCommande__c == 'Confirmée') {
                OrderService.validateOrder(ord);
            }
        }
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order ord : Trigger.new) {
            Order oldOrd = Trigger.oldMap.get(ord.Id);

            Boolean passeEnConfirme =
                    ord.Order_StatutCommande__c == 'Confirmée' &&
                            oldOrd.Order_StatutCommande__c != 'Confirmée';

            if (passeEnConfirme) {
                OrderService.validateOrder(ord);
            }
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Order ord : Trigger.new) {
            Order oldOrd = Trigger.oldMap.get(ord.Id);

            Boolean passeEnConfirme =
                    ord.Order_StatutCommande__c == 'Confirmée' &&
                            oldOrd.Order_StatutCommande__c != 'Confirmée';

            if (passeEnConfirme) {
                TransporterService.assignBestTransporter(ord);
            }
        }
    }
}
