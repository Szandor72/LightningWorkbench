({
    handleRetrievesObjectEvent: function(component, event, helper) {
        var recordId = event.getParam("recordId");
        if (!$A.util.isEmpty(recordId)) {
            component.set("v.recordId", recordId);
        }
    },

    onEditButtonClick: function(component, event, helper) {
      var toastEvent = $A.get("e.force:showToast");
      var validToast = !$A.util.isUndefinedOrNull(toastEvent);
      if (validToast) {
          toastEvent.setParams({
              "message": "Be careful when editing items directly",
              "type": "warning"
          });
          toastEvent.fire();
      }
      component.set("v.inEditMode", true);
    },

    onCancelEditButtonClick : function(component, event, helper) {
        component.set("v.inEditMode", false);
        component.set("v.searchTerm","");
    },

    onSaveButtonClick : function(component, event, helper) {
        helper.doSave(component);
        component.set("v.inEditMode", false);
        component.set("v.searchTerm","");
    },

    onRecordIdChange: function(component, event, helper) {
        if (!$A.util.isEmpty(component.get("v.recordId"))) {
            helper.retrieveSObjectById(component);
        }
        component.set("v.searchTerm","");
    },

    onCloseButtonClick: function(component, event, helper) {
        component.set("v.recordId", "");
    }
})