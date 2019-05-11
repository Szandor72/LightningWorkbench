<aura:application extends="force:slds" implements="force:hasRecordId" access="global">
    <!--aura:dependency resource="markup://force:showToast" type="EVENT"/-->
    <aura:attribute name="inEditMode" type="Boolean" access="public" default="false"
        description="If set to true will turn Value Fields into input fields"/>
    <c:retrievesObjectResult recordId="{!v.recordId}" inEditMode="{!v.inEditMode}"/>
</aura:application>