({
  call: function(component, event, helper) {
    var action = component.get("c.lightningCallout");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (component.isValid() && state === "SUCCESS") {
        var result = response.getReturnValue();
      } else if (state === "INCOMPLETE") {
        console.log("incomplete");
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
    $A.enqueueAction(action);
  },

  onInit: function(component, event, helper) {
    var empApi = component.find("empAPI");
    var replayId = -1;
    console.log("twf");
    // Subscribe to an event
    empApi
      .subscribe(
        "/event/Response__e",
        replayId,
        $A.getCallback(function(eventReceived) {
          console.log("Received event ", JSON.stringify(eventReceived));
          var response =
            eventReceived.data.payload.Payload__c +
            eventReceived.data.payload.continuedPayload1__c +
            eventReceived.data.payload.continuedPayload2__c +
            eventReceived.data.payload.continuedPayload3__c +
            eventReceived.data.payload.continuedPayload4__c;
          component.set("v.response", response);
        })
      )
      .then(function(subscription) {
        // Confirm that we have subscribed to the event channel.
        // We haven't received an event yet.
        console.log("Subscribed to channel ", subscription.channel);
        // Save subscription to unsubscribe later
        component.set("v.subscription", subscription);
      });

    // Uncomment below line to enable debug logging (optional)
    // empApi.setDebugFlag(true);

    // Register error listener and pass in the error handler function
    empApi.onError(
      $A.getCallback(function(error) {
        // Error can be any type of error (subscribe, unsubscribe...)
        console.error("EMP API error: ", JSON.stringify(error));
      })
    );
  }
});
