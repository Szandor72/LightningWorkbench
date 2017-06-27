({
    onSearchtermChange : function(component, event, helper) {
        var searchTerm = component.get("v.searchTerm");
        var fieldInfo = component.get("v.fieldInformation");
        var value = $A.util.isEmpty(fieldInfo.properties.value) ? "" : fieldInfo.properties.value;
        if (searchTerm.length > 1) {
            //debugger;
            // if field's fields dont contain searchterm            
            if (fieldInfo.name.toUpperCase().indexOf(searchTerm.toUpperCase()) === -1 &&
                fieldInfo.properties.label.toUpperCase().indexOf(searchTerm.toUpperCase()) === -1 &&
                fieldInfo.properties.displayType.toUpperCase().indexOf(searchTerm.toUpperCase()) === -1 &&
                JSON.stringify(value).toUpperCase().indexOf(searchTerm.toUpperCase()) === -1) {
                component.set("v.isMatch", false);
            } else {
                component.set("v.isMatch", true);    
            }
        } else {
            component.set("v.isMatch", true);
        }
    }
})