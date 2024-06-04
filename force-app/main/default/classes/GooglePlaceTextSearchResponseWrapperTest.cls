@isTest
public class GooglePlaceTextSearchResponseWrapperTest{
    static testMethod void testParse() {
        String json=        '{'+
        '   "html_attributions" : [],'+
        '   "results" : ['+
        '      {'+
        '         "business_status" : "OPERATIONAL",'+
        '         "formatted_address" : "315 Madison Ave Fl 3, New York, NY 10017, United States",'+
        '         "geometry" : {'+
        '            "location" : {'+
        '               "lat" : 40.7525412,'+
        '               "lng" : -73.9792042'+
        '            },'+
        '            "viewport" : {'+
        '               "northeast" : {'+
        '                  "lat" : 40.75341732989272,'+
        '                  "lng" : -73.97745192010727'+
        '               },'+
        '               "southwest" : {'+
        '                  "lat" : 40.75071767010728,'+
        '                  "lng" : -73.98015157989272'+
        '               }'+
        '            }'+
        '         },'+
        '         "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",'+
        '         "icon_background_color" : "#7B9EB0",'+
        '         "icon_mask_base_uri" : "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",'+
        '         "name" : "Madison Ave Consulting",'+
        '         "opening_hours" : {'+
        '            "open_now" : false'+
        '         },'+
        '         "place_id" : "ChIJe9T4pAFZwokRBiEbj9_93U4",'+
        '         "plus_code" : {'+
        '            "compound_code" : "Q23C+28 New York, USA",'+
        '            "global_code" : "87G8Q23C+28"'+
        '         },'+
        '         "rating" : 5,'+
        '         "reference" : "ChIJe9T4pAFZwokRBiEbj9_93U4",'+
        '         "types" : [ "point_of_interest", "establishment" ],'+
        '         "user_ratings_total" : 4'+
        '      }'+
        '   ],'+
        '   "status" : "OK"'+
        '}';
        GooglePlaceTextSearchResponseWrapper obj = GooglePlaceTextSearchResponseWrapper.parse(json);
        System.assert(obj != null);
    }
}