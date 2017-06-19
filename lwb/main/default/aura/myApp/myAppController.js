({
	toggleModal : function(component, event, helper) {
        var modal = component.find("modal");
        modal.set("v.active", !modal.get("v.active"));
	}
})