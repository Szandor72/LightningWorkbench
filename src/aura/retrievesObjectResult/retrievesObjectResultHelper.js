({
    retrieveSObjectById: function(component) {
        component.set("v.waiting", true);
        var action = component.get("c.retrieveSObject");
        var self = this;
        action.setParam("recordId", component.get("v.recordId"));
        action.setCallback(self, handleActionResponse);
        $A.enqueueAction(action);

        function dynamicSort(property) {
            var sortOrder = 1;
            if (property[0] === "-") {
                sortOrder = -1;
                property = property.substr(1);
            }
            return function(a, b) {
                var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
                return result * sortOrder;
            }
        }

        function handleActionResponse(response) {
            var state = response.getState();
            var result = response.getReturnValue();

            var toastEvent = $A.get("e.force:showToast");
            var validToast = !$A.util.isUndefinedOrNull(toastEvent);
            var message, type;
            if (component.isValid()) {
                if (state === "SUCCESS") {
                    if (result.isSuccess) {
                        //TODO label
                        try {
                            component.set('v.sObjectName', result.values.sObjectName);
                            component.set('v.lastModifiedBy', result.values.lastModifiedBy);
                            component.set('v.lastModifiedDate', result.values.lastModifiedDate);
                            var fieldsObject = JSON.parse(result.values.fields);
                            var fields = [];
                            for (var fieldName in fieldsObject) {
                                var field = {}
                                field.name = fieldName;
                                field.properties = fieldsObject[fieldName];
                                fields.push(field);
                            }
                            fields.sort(dynamicSort("name"));
                            component.set('v.fields', fields);
                            message = "Retrieved successfully: " + result.message;
                            type = "success";
                        } catch (ex) {
                            message = "Script Exception: " + ex.message;
                            type = "error"
                        }
                    } else {
                        message = result.message;
                        type = "error";
                    }
                } else {
                    var errors = response.getError();
                    message = "A server-related Error occured. Please try again.\n Technical stuff: " + JSON.stringify(errors);
                    type = "error";
                    component.set("v.waiting", false);
                    component.set("v.recordId", "");
                }
                component.set("v.waiting", false);
            }
            if (validToast) {
                toastEvent.setParams({
                    "message": message,
                    "type": type,
                    "mode": type === "error" ? "sticky" : "dismissible"
                });
                toastEvent.fire()
            } else {
                var toastMessage = type + " - " + message;
                component.set("v.messages", toastMessage);
            }
        }
    },

    doSave : function(component) {
        component.set("v.waiting", true);
        var action = component.get("c.updatesObject");
        var self = this;
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "sObjectName" : component.get("v.sObjectName"),
            "fieldsJSON" : JSON.stringify(component.get("v.fields"))
        });
        action.setCallback(self, handleActionResponse);
        $A.enqueueAction(action);

        function handleActionResponse(response){
            var state = response.getState();
            var result = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            var validToast = !$A.util.isUndefinedOrNull(toastEvent);
            var message, type;
            if (state === "SUCCESS") {
                if (result.isSuccess) {
                    message = "Saved successfully: " + component.get("v.sObjectName");
                    type = "success";
                    component.set("v.inEditMode", false);
                    component.set("v.searchTerm","");
                } else {
                    message = result.message;
                    type = "error";
                }
            } else {
                var errors = response.getError();
                message = "A server-related Error occured. Please try again.\n Technical stuff: " + JSON.stringify(errors);
                type = "error";
                component.set("v.waiting", false);
               // component.set("v.recordId", "");
            }
            component.set("v.waiting", false);
                
            if (validToast) {
                toastEvent.setParams({
                    "message": message,
                    "type": type,
                    "mode": type === "error" ? "sticky" : "dismissible"
                });
                toastEvent.fire()
            } else {
                var toastMessage = type + " - " + message;
                component.set("v.messages", toastMessage);
            }
        }
    }
})