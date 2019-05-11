# Lightning Workbench

Tools for awesome Salesforce Admins and Devs

# Purpose

Open Source Package that functions

1.  as a test package for a CumulusCI setup
2.  as a test package for SalesforceDX workflow - cf. http://www.shoreforce.net (German)
3.  Exemplary folder usage for a DX project
4.  Hacky way to get straightforward API Access via Lightning
5.  attempt at providing some Salesforce Workbench Functions and other Goodies within Salesforce Lightning Experience - stalled.

# Content

- retrievesObjectCard for all PageTypes, will work with current recordId if present
- Lightning API Access via @future call & platform event
- Example App containing retrievesObjectCard / lightningAPI Access on the Account Layout

# Functions

- sObject Retrieve with FLS n All
- save Edits to sObject incl Picklist Support
- displays for Admins only (only Users whose Profile has `PersmissionsModifyAllData` and `PermissionsViewAllData`)
