({
    defaultCloseAction : function(component, event, helper) {
        component.set("v.active",false);
        component.set("v.waiting",false);
    },
		onWaitingChange : function(component, event, helper) {
		 		if(component.get("v.waiting")){
          component.set("v.closeable", false);
        }
		},
    onActiveChange : function(component, event, helper) {
        component.set("v.waiting", false);
    }
})