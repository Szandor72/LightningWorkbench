public with sharing class AuraActionResponse {

    @AuraEnabled
    public Boolean isSuccess { get; set; }

    @AuraEnabled
    public String message { get; set; }

    @AuraEnabled
    public Map<Object, Object> values { get; set; }

    /**
     * Default constructor when operation was successful without return data
     */
    public AuraActionResponse() {
        this(true, '', null, null);
    }

    /**
     * Default constructor when operation was successful with return data
     */
    public AuraActionResponse(Object key, Object value) {
        this(true, '', key, value);
    }

    /**
     * Default constructor when operation has failed
     */
    public AuraActionResponse(String message) {
        this(false, message, null, null);
    }

    /**
     * Constructor, defines wether operation was successful and holds storage
     * for additional error message and all key-value paired return data
     */
    public AuraActionResponse(Boolean isSuccess, String msg, Object key, Object value) {
        this.isSuccess  = isSuccess;
        this.message    = msg;
        this.values     = new Map<Object, Object>();

        if(key != null)
        {
            this.values.put(key, value);
        }
    }
}