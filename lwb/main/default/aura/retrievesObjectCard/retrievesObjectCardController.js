({
	onInit : function(component, event, helper) {
        var action = component.get("c.checkPermissions");
        var self = this;
        action.setCallback(self, function(response){
            component.set("v.isUserAdmin", response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})