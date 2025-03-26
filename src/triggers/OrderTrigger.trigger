trigger OrderTrigger on Order (before insert, before update) {
    // Vérifier si la commande répond aux critères de validation
    for(Order order : Trigger.new) {
        // Vérifier le nombre minimum de produits selon le type de client
        if(order.Account.Acc_TypeClient__c == 'Particulier' && order.Order_NombreProduits__c < 3) {
            order.addError('Le nombre minimum de produits pour un particulier est de 3');
        } else if(order.Account.Acc_TypeClient__c == 'Professionnel' && order.Order_NombreProduits__c < 5) {
            order.addError('Le nombre minimum de produits pour un professionnel est de 5');
        }
    }
}