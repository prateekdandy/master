public class GooglePlaceTextSearchResponseWrapper{
    
    public cls_results[] results;
    public String status;   //OK
    public String error_message;
    
    public class cls_results {
        public String business_status;  //OPERATIONAL
        public String formatted_address;    //315 Madison Ave Fl 3, New York, NY 10017, United States
        public cls_geometry geometry;
        public String icon; //https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png
        public String icon_background_color;    //#7B9EB0
        public String icon_mask_base_uri;   //https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet
        public String name; //Madison Ave Consulting
        public cls_opening_hours opening_hours;
        public cls_photos[] photos;
        public String place_id; //ChIJe9T4pAFZwokRBiEbj9_93U4
        public cls_plus_code plus_code;
        public String rating;  //5
        public String reference;    //ChIJe9T4pAFZwokRBiEbj9_93U4
        public String[] types;
        public Integer user_ratings_total;  //4
    }
    class cls_geometry {
        public cls_location location;
        public cls_viewport viewport;
    }
    class cls_location {
        public Double lat;  //40.7525412
        public Double lng;  //-73.9792042
    }
    class cls_viewport {
        public cls_northeast northeast;
        public cls_southwest southwest;
    }
    class cls_northeast {
        public Double lat;  //40.75341732989272
        public Double lng;  //-73.97745192010727
    }
    class cls_southwest {
        public Double lat;  //40.75071767010728
        public Double lng;  //-73.98015157989272
    }
    class cls_opening_hours {
        public boolean open_now;
    }
    class cls_photos {
        public Integer height;  //426
        
        public String photo_reference;  //Aap_uECfllx9pxY3dS-6TWhooW1rIaOXkuDoV2G_vMaeAGlg0ax5MQGstyAbS5SiOXxvSX3VPbnC7peWhqyz77b1dTMqUPWNvNFHm_mHbOreA2dLXXtDec5oJRVDch-9WX88eGjPoLZBEf5SfHqEBoF1qSLe6EEH09Tico3r1p0IpIDuRlg3
        public Integer width;   //1250
    }
    class cls_plus_code {
        public String compound_code;    //Q23C+28 New York, USA
        public String global_code;  //87G8Q23C+28
    }
    public static GooglePlaceTextSearchResponseWrapper parse(String json){
        return (GooglePlaceTextSearchResponseWrapper) System.JSON.deserialize(json, GooglePlaceTextSearchResponseWrapper.class);
    }

}