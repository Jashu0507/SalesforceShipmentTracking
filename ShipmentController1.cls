public with sharing class ShipmentController1 {
    @AuraEnabled(cacheable=true)
    public static String getStatus(String recordId) {
        try {
            // Here Iam Fetching the shipment record
            Shipment__c shipment = [SELECT Name, TrackingNumber__c FROM Shipment__c WHERE Id = :recordId LIMIT 1];
            // here iam Convert  TrackingNumber__c to a String
            String trackingNumber = String.valueOf(shipment.TrackingNumber__c);
            //here iam  Check if the shipment record or its Tracking_Number__c field is empty
            if (shipment == null || String.isEmpty(trackingNumber)) {
                throw new AuraHandledException('Tracking number cannot be found or is empty.');
            }
            // here iam Create and configure the HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://merzcommunities--mel.sandbox.my.salesforce-sites.com/services/apexrest/mockShipmentStatus?trackingNumber=' + EncodingUtil.urlEncode(trackingNumber, 'UTF-8'));
            req.setMethod('GET');
            // here iam Send the HTTP request and get the response
            Http http = new Http();
            HttpResponse res = http.send(req);
            // here Check the response status and return the response body or throw an error
            if (res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                throw new AuraHandledException('Error: ' + res.getStatus());
            }
        } catch (Exception e) {
            throw new AuraHandledException('An unexpected error occurred. Please try again later.');
        }
    }
}