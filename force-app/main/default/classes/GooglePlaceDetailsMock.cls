global class GooglePlaceDetailsMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String json = '{'+
        '   \"html_attributions\" : [],'+
        '   \"result\" : {'+
        '      \"address_components\" : ['+
        '         {'+
        '            \"long_name\" : \"Fl 3\",'+
        '            \"short_name\" : \"Fl 3\",'+
        '            \"types\" : [ \"subpremise\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"315\",'+
        '            \"short_name\" : \"315\",'+
        '            \"types\" : [ \"street_number\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"Madison Avenue\",'+
        '            \"short_name\" : \"Madison Ave\",'+
        '            \"types\" : [ \"route\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"Manhattan\",'+
        '            \"short_name\" : \"Manhattan\",'+
        '            \"types\" : [ \"sublocality_level_1\", \"sublocality\", \"political\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"New York\",'+
        '            \"short_name\" : \"New York\",'+
        '            \"types\" : [ \"locality\", \"political\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"New York County\",'+
        '            \"short_name\" : \"New York County\",'+
        '            \"types\" : [ \"administrative_area_level_2\", \"political\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"New York\",'+
        '            \"short_name\" : \"NY\",'+
        '            \"types\" : [ \"administrative_area_level_1\", \"political\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"United States\",'+
        '            \"short_name\" : \"US\",'+
        '            \"types\" : [ \"country\", \"political\" ]'+
        '         },'+
        '         {'+
        '            \"long_name\" : \"10017\",'+
        '            \"short_name\" : \"10017\",'+
        '            \"types\" : [ \"postal_code\" ]'+
        '         }'+
        '      ],'+
        '      \"adr_address\" : \"\\u003cspan class=\\\"street-address\\\"\\u003e315 Madison Ave Fl 3\\u003c/span\\u003e, \\u003cspan class=\\\"locality\\\"\\u003eNew York\\u003c/span\\u003e, \\u003cspan class=\\\"region\\\"\\u003eNY\\u003c/span\\u003e \\u003cspan class=\\\"postal-code\\\"\\u003e10017\\u003c/span\\u003e, \\u003cspan class=\\\"country-name\\\"\\u003eUSA\\u003c/span\\u003e\",'+
        '      \"business_status\" : \"OPERATIONAL\",'+
        '      \"formatted_address\" : \"315 Madison Ave Fl 3, New York, NY 10017, USA\",'+
        '      \"formatted_phone_number\" : \"(212) 339-7426\",'+
        '      \"geometry\" : {'+
        '         \"location\" : {'+
        '            \"lat\" : 40.7525412,'+
        '            \"lng\" : -73.9792042'+
        '         },'+
        '         \"viewport\" : {'+
        '            \"northeast\" : {'+
        '               \"lat\" : 40.75341648029149,'+
        '               \"lng\" : -73.97745276970849'+
        '            },'+
        '            \"southwest\" : {'+
        '               \"lat\" : 40.75071851970849,'+
        '               \"lng\" : -73.9801507302915'+
        '            }'+
        '         }'+
        '      },'+
        '      \"icon\" : \"https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png\",'+
        '      \"icon_background_color\" : \"#7B9EB0\",'+
        '      \"icon_mask_base_uri\" : \"https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet\",'+
        '      \"international_phone_number\" : \"+1 212-339-7426\",'+
        '      \"name\" : \"Madison Ave Consulting\",'+
        '      \"opening_hours\" : {'+
        '         \"open_now\" : false,'+
        '         \"periods\" : ['+
        '            {'+
        '               \"close\" : {'+
        '                  \"day\" : 1,'+
        '                  \"time\" : \"2000\"'+
        '               },'+
        '               \"open\" : {'+
        '                  \"day\" : 1,'+
        '                  \"time\" : \"0800\"'+
        '               }'+
        '            },'+
        '            {'+
        '               \"close\" : {'+
        '                  \"day\" : 2,'+
        '                  \"time\" : \"2000\"'+
        '               },'+
        '               \"open\" : {'+
        '                  \"day\" : 2,'+
        '                  \"time\" : \"0800\"'+
        '               }'+
        '            },'+
        '            {'+
        '               \"close\" : {'+
        '                  \"day\" : 3,'+
        '                  \"time\" : \"2000\"'+
        '               },'+
        '               \"open\" : {'+
        '                  \"day\" : 3,'+
        '                  \"time\" : \"0800\"'+
        '               }'+
        '            },'+
        '            {'+
        '               \"close\" : {'+
        '                  \"day\" : 4,'+
        '                  \"time\" : \"2000\"'+
        '               },'+
        '               \"open\" : {'+
        '                  \"day\" : 4,'+
        '                  \"time\" : \"0800\"'+
        '               }'+
        '            },'+
        '            {'+
        '               \"close\" : {'+
        '                  \"day\" : 5,'+
        '                  \"time\" : \"2000\"'+
        '               },'+
        '               \"open\" : {'+
        '                  \"day\" : 5,'+
        '                  \"time\" : \"0800\"'+
        '               }'+
        '            }'+
        '         ],'+
        '         \"weekday_text\" : ['+
        '            \"Monday: 8:00 AM – 8:00 PM\",'+
        '            \"Tuesday: 8:00 AM – 8:00 PM\",'+
        '            \"Wednesday: 8:00 AM – 8:00 PM\",'+
        '            \"Thursday: 8:00 AM – 8:00 PM\",'+
        '            \"Friday: 8:00 AM – 8:00 PM\",'+
        '            \"Saturday: Closed\",'+
        '            \"Sunday: Closed\"'+
        '         ]'+
        '      },'+
        '      \"photos\" : ['+
        '         {'+
        '            \"height\" : 426,'+
        '            \"html_attributions\" : ['+
        '               \"\\u003ca href=\\\"https://maps.google.com/maps/contrib/101358570130366548874\\\"\\u003eMadison Ave Consulting\\u003c/a\\u003e\"'+
        '            ],'+
        '            \"photo_reference\" : \"Aap_uECqbOdZ0FrK4y7jUqoTUU3ATIjCN1tmN__F23XNdFaAgoFotwpMRsytij9r8DUtKPeKO_lLEN_lQL3OGDXVI2_7saAPwWtODGVnk7pMUsN75Y3tAdMMKHaKuFgIotlhkhG4h7VLk3jNxfP5eUmrNm2gMbSjymflXb_ovXzpJVdPXsqs\",'+
        '            \"width\" : 1250'+
        '         },'+
        '         {'+
        '            \"height\" : 571,'+
        '            \"html_attributions\" : ['+
        '               \"\\u003ca href=\\\"https://maps.google.com/maps/contrib/101358570130366548874\\\"\\u003eMadison Ave Consulting\\u003c/a\\u003e\"'+
        '            ],'+
        '            \"photo_reference\" : \"Aap_uEBwYZdZoyQZMD9d9sjbNmLlhSZOVUJvtgp3fcb21PdabUVseBzNLUUUKmaCU1bS-53Ifaf2ov5Cq6EwigYdf5cU0tPPHdptPoi43AyEqljsbh-vFMSLHtGxw7cgArX_70G3fJBvolB0unuVlp4DUMAK_pgxVbSar5hiufCXJwqBenYI\",'+
        '            \"width\" : 539'+
        '         },'+
        '         {'+
        '            \"height\" : 360,'+
        '            \"html_attributions\" : ['+
        '               \"\\u003ca href=\\\"https://maps.google.com/maps/contrib/101358570130366548874\\\"\\u003eMadison Ave Consulting\\u003c/a\\u003e\"'+
        '            ],'+
        '            \"photo_reference\" : \"Aap_uECk4f4LRReydEcW_phyRhqQfIE-TWaB2PXVs2r6_8QdT_bg9F7E1-6g_pnMOMBL7DZ08bKRc5FjvhMyKJMdYNNgHxPhqaaISs9ZzOOuawmINWX3ywAcS5EOEOXozbCRiJ1oHU_qWuPO6XuW48iASc4sp4XiRw13qpEjKAo2L4QSQI1L\",'+
        '            \"width\" : 360'+
        '         }'+
        '      ],'+
        '      \"place_id\" : \"ChIJe9T4pAFZwokRBiEbj9_93U4\",'+
        '      \"plus_code\" : {'+
        '         \"compound_code\" : \"Q23C+28 New York, NY, USA\",'+
        '         \"global_code\" : \"87G8Q23C+28\"'+
        '      },'+
        '      \"rating\" : 5,'+
        '      \"reference\" : \"ChIJe9T4pAFZwokRBiEbj9_93U4\",'+
        '      \"reviews\" : ['+
        '         {'+
        '            \"author_name\" : \"Margaret Williams\",'+
        '            \"author_url\" : \"https://www.google.com/maps/contrib/106885618225409469671/reviews\",'+
        '            \"language\" : \"en\",'+
        '            \"profile_photo_url\" : \"https://lh3.googleusercontent.com/a/AATXAJxDtlqOMnYwk65omEZjm43ZYYEDSAkaVY0Xv8x3=s128-c0x00000000-cc-rp-mo\",'+
        '            \"rating\" : 5,'+
        '            \"relative_time_description\" : \"2 years ago\",'+
        '            \"text\" : \"Madison Ave Consulting helped us immensely in getting our salesforce account off the ground and functioning. As a small, but ambitious non-profit, this type of dedicated, detail-oriented, accessible and highly informed support was invaluable in helping us organize our contacts and scale our outreach. I could not recommend Madison Ave Consulting highly enough.\",'+
        '            \"time\" : 1578417818'+
        '         },'+
        '         {'+
        '            \"author_name\" : \"Ashlee Rogers\",'+
        '            \"author_url\" : \"https://www.google.com/maps/contrib/117549971810800170210/reviews\",'+
        '            \"language\" : \"en\",'+
        '            \"profile_photo_url\" : \"https://lh3.googleusercontent.com/a-/AOh14Gjz2dCc1IS_AZJH5i_Tx1BMUVa5Nacl_F140eTMdg=s128-c0x00000000-cc-rp-mo\",'+
        '            \"rating\" : 5,'+
        '            \"relative_time_description\" : \"2 years ago\",'+
        '            \"text\" : \"Adam at Madison Ave Consulting has done a stellar job helping us with some very complex Salesforce projects. Our projects tend to really flex the limits of Salesforce and require creative solutions. Madison Ave has been able to deliver on all of our crazy ideas and make them come alive! We will continue to partner with them for future projects.\",'+
        '            \"time\" : 1577985398'+
        '         },'+
        '         {'+
        '            \"author_name\" : \"Becca Braun\",'+
        '            \"author_url\" : \"https://www.google.com/maps/contrib/110437878573018060398/reviews\",'+
        '            \"language\" : \"en\",'+
        '            \"profile_photo_url\" : \"https://lh3.googleusercontent.com/a/AATXAJyXOM20gfEivSmrirrkEnj0zATryNyd_cTnq4HG3g=s128-c0x00000000-cc-rp-mo\",'+
        '            \"rating\" : 5,'+
        '            \"relative_time_description\" : \"2 years ago\",'+
        '            \"text\" : \"Mitch Ebin of Madison Ave does a terrific job on helping my small business and me with our SalesForce (and other apps) needs. He researches well, makes solid recommendations, is a very good communicator, and respects my business objectives. I recommend highly.\",'+
        '            \"time\" : 1576535583'+
        '         },'+
        '         {'+
        '            \"author_name\" : \"Nicholas Astier\",'+
        '            \"author_url\" : \"https://www.google.com/maps/contrib/116758350901603002676/reviews\",'+
        '            \"language\" : \"en\",'+
        '            \"profile_photo_url\" : \"https://lh3.googleusercontent.com/a-/AOh14GiN_QxfC-IyXRWH3WvUU8IIiuke89AT1XWkKUMc=s128-c0x00000000-cc-rp-mo\",'+
        '            \"rating\" : 5,'+
        '            \"relative_time_description\" : \"2 years ago\",'+
        '            \"text\" : \"Mitch Ebin at Madison Ave Consulting has been helping me and pretty much everyone else at the World Federation of United Nations Associations with Salesforce for more than two years now and he has been nothing short of amazing! He is very reachable and responds to his emails quickly, always helping us with any issues we have. He has trained a number of employees in our New York office but has also been training some of the staff in the Geneva office as well, and always makes himself available to help interns and new staff members. I would absolutely recommend Mitch and Madison Ave Consulting to anyone or any organization that needs help with Salesforce.\",'+
        '            \"time\" : 1576548959'+
        '         }'+
        '      ],'+
        '      \"types\" : [ \"point_of_interest\", \"establishment\" ],'+
        '      \"url\" : \"https://maps.google.com/?cid=5682977441431888134\",'+
        '      \"user_ratings_total\" : 4,'+
        '      \"utc_offset\" : -300,'+
        '      \"vicinity\" : \"315 Madison Avenue Fl 3, New York\",'+
        '      \"website\" : \"http://madisonaveconsulting.com/\"'+
        '   },'+
        '   \"status\" : \"OK\"'+
        '}';
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
}