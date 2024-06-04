public class GooglePlaceDetailWrapper {

    public List<Html_attributions> html_attributions {get;set;} 
    @auraEnabled public Result result {get;set;} 
    @auraEnabled public String status {get;set;} 
    @auraEnabled public String error_message {get;set;}

    public GooglePlaceDetailWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'html_attributions') {
                        html_attributions = arrayOfHtml_attributions(parser);
                    } else if (text == 'result') {
                        result = new Result(parser);
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'error_message') {
                        error_message = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'GooglePlaceDetailWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Opening_hours {
        public Boolean open_now {get;set;} 
        public List<Periods> periods {get;set;} 
        @auraEnabled public List<String> weekday_text {get;set;} 

        public Opening_hours(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'open_now') {
                            open_now = parser.getBooleanValue();
                        } else if (text == 'periods') {
                            periods = arrayOfPeriods(parser);
                        } else if (text == 'weekday_text') {
                            weekday_text = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Opening_hours consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Viewport {
        public Location northeast {get;set;} 
        public Location southwest {get;set;} 

        public Viewport(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'northeast') {
                            northeast = new Location(parser);
                        } else if (text == 'southwest') {
                            southwest = new Location(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Viewport consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Html_attributions {

        public Html_attributions(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Html_attributions consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Result {
        public List<Address_components> address_components {get;set;} 
        public String adr_address {get;set;} 
        @auraEnabled public String business_status {get;set;} 
        @auraEnabled public String formatted_address {get;set;} 
        @auraEnabled public String formatted_phone_number {get;set;} 
        public Geometry geometry {get;set;} 
        public String icon {get;set;} 
        public String icon_background_color {get;set;} 
        public String icon_mask_base_uri {get;set;} 
        @auraEnabled public String international_phone_number {get;set;} 
        @auraEnabled public String name {get;set;} 
        @auraEnabled public Opening_hours opening_hours {get;set;} 
        public List<Photos> photos {get;set;} 
        @auraEnabled public String place_id {get;set;} 
        public Plus_code plus_code {get;set;} 
        public Integer rating {get;set;} 
        public String reference {get;set;} 
        public List<Reviews> reviews {get;set;} 
        public List<String> types {get;set;} 
        @auraEnabled public String url {get;set;} 
        public Integer user_ratings_total {get;set;} 
        @auraEnabled public Integer utc_offset {get;set;} 
        public String vicinity {get;set;} 
        @auraEnabled public String website {get;set;} 

        public Result(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address_components') {
                            address_components = arrayOfAddress_components(parser);
                        } else if (text == 'adr_address') {
                            adr_address = parser.getText();
                        } else if (text == 'business_status') {
                            business_status = parser.getText();
                        } else if (text == 'formatted_address') {
                            formatted_address = parser.getText();
                        } else if (text == 'formatted_phone_number') {
                            formatted_phone_number = parser.getText();
                        } else if (text == 'geometry') {
                            geometry = new Geometry(parser);
                        } else if (text == 'icon') {
                            icon = parser.getText();
                        } else if (text == 'icon_background_color') {
                            icon_background_color = parser.getText();
                        } else if (text == 'icon_mask_base_uri') {
                            icon_mask_base_uri = parser.getText();
                        } else if (text == 'international_phone_number') {
                            international_phone_number = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'opening_hours') {
                            opening_hours = new Opening_hours(parser);
                        } else if (text == 'photos') {
                            photos = arrayOfPhotos(parser);
                        } else if (text == 'place_id') {
                            place_id = parser.getText();
                        } else if (text == 'plus_code') {
                            plus_code = new Plus_code(parser);
                        } else if (text == 'rating') {
                            rating = parser.getIntegerValue();
                        } else if (text == 'reference') {
                            reference = parser.getText();
                        } else if (text == 'reviews') {
                            reviews = arrayOfReviews(parser);
                        } else if (text == 'types') {
                            types = arrayOfString(parser);
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else if (text == 'user_ratings_total') {
                            user_ratings_total = parser.getIntegerValue();
                        } else if (text == 'utc_offset') {
                            utc_offset = parser.getIntegerValue();
                        } else if (text == 'vicinity') {
                            vicinity = parser.getText();
                        } else if (text == 'website') {
                            website = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address_components {
        public String long_name {get;set;} 
        public String short_name {get;set;} 
        public List<String> types {get;set;} 

        public Address_components(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'long_name') {
                            long_name = parser.getText();
                        } else if (text == 'short_name') {
                            short_name = parser.getText();
                        } else if (text == 'types') {
                            types = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address_components consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Geometry {
        public Location location {get;set;} 
        public Viewport viewport {get;set;} 

        public Geometry(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'location') {
                            location = new Location(parser);
                        } else if (text == 'viewport') {
                            viewport = new Viewport(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Geometry consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Photos {
        public Integer height {get;set;} 
        public List<String> html_attributions {get;set;} 
        public String photo_reference {get;set;} 
        public Integer width {get;set;} 

        public Photos(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'height') {
                            height = parser.getIntegerValue();
                        } else if (text == 'html_attributions') {
                            html_attributions = arrayOfString(parser);
                        } else if (text == 'photo_reference') {
                            photo_reference = parser.getText();
                        } else if (text == 'width') {
                            width = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Photos consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Periods {
        public Close close {get;set;} 
        public Close open {get;set;} 

        public Periods(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'close') {
                            close = new Close(parser);
                        } else if (text == 'open') {
                            open = new Close(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Periods consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Plus_code {
        public String compound_code {get;set;} 
        public String global_code {get;set;} 

        public Plus_code(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'compound_code') {
                            compound_code = parser.getText();
                        } else if (text == 'global_code') {
                            global_code = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Plus_code consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Reviews {
        public String author_name {get;set;} 
        public String author_url {get;set;} 
        public String language {get;set;} 
        public String profile_photo_url {get;set;} 
        public Integer rating {get;set;} 
        public String relative_time_description {get;set;} 
        public String text {get;set;} 
        public Integer time_Z {get;set;} // in json: time

        public Reviews(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'author_name') {
                            author_name = parser.getText();
                        } else if (text == 'author_url') {
                            author_url = parser.getText();
                        } else if (text == 'language') {
                            language = parser.getText();
                        } else if (text == 'profile_photo_url') {
                            profile_photo_url = parser.getText();
                        } else if (text == 'rating') {
                            rating = parser.getIntegerValue();
                        } else if (text == 'relative_time_description') {
                            relative_time_description = parser.getText();
                        } else if (text == 'text') {
                            text = parser.getText();
                        } else if (text == 'time') {
                            time_Z = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Reviews consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Close {
        public Integer day {get;set;} 
        public String time_Z {get;set;} // in json: time

        public Close(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'day') {
                            day = parser.getIntegerValue();
                        } else if (text == 'time') {
                            time_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Close consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Location {
        public Double lat {get;set;} 
        public Double lng {get;set;} 

        public Location(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'lat') {
                            lat = parser.getDoubleValue();
                        } else if (text == 'lng') {
                            lng = parser.getDoubleValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static GooglePlaceDetailWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new GooglePlaceDetailWrapper(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    





    private static List<Html_attributions> arrayOfHtml_attributions(System.JSONParser p) {
        List<Html_attributions> res = new List<Html_attributions>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Html_attributions(p));
        }
        return res;
    }


    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }





    private static List<Reviews> arrayOfReviews(System.JSONParser p) {
        List<Reviews> res = new List<Reviews>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Reviews(p));
        }
        return res;
    }



    private static List<Address_components> arrayOfAddress_components(System.JSONParser p) {
        List<Address_components> res = new List<Address_components>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Address_components(p));
        }
        return res;
    }










    private static List<Periods> arrayOfPeriods(System.JSONParser p) {
        List<Periods> res = new List<Periods>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Periods(p));
        }
        return res;
    }


    private static List<Photos> arrayOfPhotos(System.JSONParser p) {
        List<Photos> res = new List<Photos>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Photos(p));
        }
        return res;
    }


}