<aura:application extends="force:slds">
    <lightning:button label="toggle Modal" onclick="{!c.toggleModal}"/>
    <c:modal aura:id="modal" size="large"/>	
</aura:application>