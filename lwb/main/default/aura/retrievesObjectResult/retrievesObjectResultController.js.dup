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
              "message": "Coming soon. Stay tuned",
              "type": "warning"
          });
          toastEvent.fire();
      }
    },

    onRecordIdChange: function(component, event, helper) {
        if (!$A.util.isEmpty(component.get("v.recordId"))) {
            helper.retrieveSObjectById(component);
        }
    },

    onCloseButtonClick: function(component, event, helper) {
        component.set("v.recordId", "");
    }
})