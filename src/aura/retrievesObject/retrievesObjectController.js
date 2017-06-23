({
    onRetrieveButtonClick : function(component, event, helper) {
        var recordIdChange = $A.get("e.c:retrievesObjectEvent");
        recordIdChange.setParam("recordId", component.get("v.recordId"));
        recordIdChange.fire();
    },
    
    openModal : function(component, event, helper) {
        var modal = component.find("modal");
        modal.set("v.size", "large");
        modal.set("v.active", true);
    },
    
    gotoResults : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:retrievesObjectResult",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();
    }
})