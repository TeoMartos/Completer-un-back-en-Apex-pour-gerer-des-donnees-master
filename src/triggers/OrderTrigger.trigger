trigger OrderTrigger on Order (before insert, before update) {
    for (Order ord : Trigger.new) {
        OrderService.validateOrder(ord);
    }
}
