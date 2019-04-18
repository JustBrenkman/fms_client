import 'dart:convert';

import 'package:fms_client/redux/fms_models.dart';

class Data {
  final String eventData = "data: {" + "[\n" +
      "      {\n" +
      "         \"eventType\":\"birth\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"city\":\"Melbourne\",\n" +
      "         \"country\":\"Australia\",\n" +
      "         \"latitude\":-36.1833,\n" +
      "         \"longitude\":144.9667,\n" +
      "         \"year\":1970,\n" +
      "         \"eventID\":\"Sheila_Birth\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"marriage\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"city\":\"Los Angeles\",\n" +
      "         \"country\":\"United States\",\n" +
      "         \"latitude\":34.0500,\n" +
      "         \"longitude\":-117.7500,\n" +
      "         \"year\":2012,\n" +
      "         \"eventID\":\"Sheila_Marriage\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"completed asteroids\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"city\":\"Qaanaaq\",\n" +
      "         \"country\":\"Denmark\",\n" +
      "         \"latitude\":77.4667,\n" +
      "         \"longitude\":-68.7667,\n" +
      "         \"year\":2014,\n" +
      "         \"eventID\":\"Sheila_Asteroids\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"COMPLETED ASTEROIDS\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"city\":\"Qaanaaq\",\n" +
      "         \"country\":\"Denmark\",\n" +
      "         \"latitude\":74.4667,\n" +
      "         \"longitude\":-60.7667,\n" +
      "         \"year\":2014,\n" +
      "         \"eventID\":\"Other_Asteroids\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"death\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"city\":\"Provo\",\n" +
      "         \"country\":\"United States\",\n" +
      "         \"latitude\":40.2444,\n" +
      "         \"longitude\":111.6608,\n" +
      "         \"year\":2015,\n" +
      "         \"eventID\":\"Sheila_Death\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"birth\",\n" +
      "         \"personID\":\"Davis_Hyer\",\n" +
      "         \"city\":\"Hakodate\",\n" +
      "         \"country\":\"Japan\",\n" +
      "         \"latitude\":41.7667,\n" +
      "         \"longitude\":140.7333,\n" +
      "         \"year\":1970,\n" +
      "         \"eventID\":\"Davis_Birth\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"birth\",\n" +
      "         \"personID\":\"Blaine_McGary\",\n" +
      "         \"city\":\"Bratsk\",\n" +
      "         \"country\":\"Russia\",\n" +
      "         \"latitude\":56.1167,\n" +
      "         \"longitude\":101.6000,\n" +
      "         \"year\":1948,\n" +
      "         \"eventID\":\"Blaine_Birth\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"death\",\n" +
      "         \"personID\":\"Betty_White\",\n" +
      "         \"city\":\"Birmingham\",\n" +
      "         \"country\":\"United Kingdom\",\n" +
      "         \"latitude\":52.4833,\n" +
      "         \"longitude\":-0.1000,\n" +
      "         \"year\":2017,\n" +
      "         \"eventID\":\"Betty_Death\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"Graduated from BYU\",\n" +
      "         \"personID\":\"Ken_Rodham\",\n" +
      "         \"country\": \"United States\",\n" +
      "         \"city\": \"Provo\",\n" +
      "         \"latitude\": 40.2338,\n" +
      "         \"longitude\": -111.6585,\n" +
      "         \"year\":1879,\n" +
      "         \"eventID\":\"BYU_graduation\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"marriage\",\n" +
      "         \"personID\":\"Ken_Rodham\",\n" +
      "         \"country\": \"North Korea\",\n" +
      "         \"city\": \"Wonsan\",\n" +
      "         \"latitude\": 39.15,\n" +
      "         \"longitude\": 127.45,\n" +
      "         \"year\":1895,\n" +
      "         \"eventID\":\"Rodham_Marriage\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"Did a backflip\",\n" +
      "         \"personID\":\"Mrs_Rodham\",\n" +
      "         \"country\": \"Mexico\",\n" +
      "         \"city\": \"Mexicali\",\n" +
      "         \"latitude\": 32.6667,\n" +
      "         \"longitude\": -114.5333,\n" +
      "         \"year\":1890,\n" +
      "         \"eventID\":\"Mrs_Rodham_Backflip\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"learned Java\",\n" +
      "         \"personID\":\"Mrs_Rodham\",\n" +
      "         \"country\": \"Algeria\",\n" +
      "         \"city\": \"Algiers\",\n" +
      "         \"latitude\": 36.7667,\n" +
      "         \"longitude\": 3.2167,\n" +
      "         \"year\":1890,\n" +
      "         \"eventID\":\"Mrs_Rodham_Java\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"Caught a frog\",\n" +
      "         \"personID\":\"Frank_Jones\",\n" +
      "         \"country\": \"Bahamas\",\n" +
      "         \"city\": \"Nassau\",\n" +
      "         \"latitude\": 25.0667,\n" +
      "         \"longitude\": -76.6667,\n" +
      "         \"year\":1993,\n" +
      "         \"eventID\":\"Jones_Frog\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"marriage\",\n" +
      "         \"personID\":\"Frank_Jones\",\n" +
      "         \"country\": \"Ghana\",\n" +
      "         \"city\": \"Tamale\",\n" +
      "         \"latitude\": 9.4,\n" +
      "         \"longitude\": 0.85,\n" +
      "         \"year\":1997,\n" +
      "         \"eventID\":\"Jones_Marriage\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"Ate Brazilian Barbecue\",\n" +
      "         \"personID\":\"Mrs_Jones\",\n" +
      "         \"country\": \"Brazil\",\n" +
      "         \"city\": \"Curitiba\",\n" +
      "         \"latitude\": -24.5833,\n" +
      "         \"longitude\": -48.75,\n" +
      "         \"year\":2012,\n" +
      "         \"eventID\":\"Mrs_Jones_Barbecue\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"Learned to Surf\",\n" +
      "         \"personID\":\"Mrs_Jones\",\n" +
      "         \"country\": \"Australia\",\n" +
      "         \"city\": \"Gold Coast\",\n" +
      "         \"latitude\": -27.9833,\n" +
      "         \"longitude\": 153.4,\n" +
      "         \"year\": 2000,\n" +
      "         \"eventID\":\"Mrs_Jones_Surf\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"birth\",\n" +
      "         \"personID\":\"Patrick_Spencer\",\n" +
      "         \"city\":\"Grise Fiord\",\n" +
      "         \"country\":\"Canada\",\n" +
      "         \"latitude\":76.4167,\n" +
      "         \"longitude\":-81.1,\n" +
      "         \"year\":2016,\n" +
      "         \"eventID\":\"Thanks_Woodfield\",\n" +
      "         \"descendant\":\"patrick\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"marriage\",\n" +
      "         \"personID\":\"Happy_Birthday\",\n" +
      "         \"city\":\"Boise\",\n" +
      "         \"country\":\"United States\",\n" +
      "         \"latitude\":43.6167,\n" +
      "         \"longitude\":-115.8,\n" +
      "         \"year\":2016,\n" +
      "         \"eventID\":\"True_Love\",\n" +
      "         \"descendant\":\"patrick\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"eventType\":\"marriage\",\n" +
      "         \"personID\":\"Golden_Boy\",\n" +
      "         \"city\":\"Boise\",\n" +
      "         \"country\":\"United States\",\n" +
      "         \"latitude\":43.6167,\n" +
      "         \"longitude\":-115.8,\n" +
      "         \"year\":2016,\n" +
      "         \"eventID\":\"Together_Forever\",\n" +
      "         \"descendant\":\"patrick\"\n" +
      "      }\n" +
      "   ]" + "}";

  final String peopleData = "data: {" + "\":[\n" +
      "      {\n" +
      "         \"firstName\":\"Sheila\",\n" +
      "         \"lastName\":\"Parker\",\n" +
      "         \"gender\":\"f\",\n" +
      "         \"personID\":\"Sheila_Parker\",\n" +
      "         \"spouse\":\"Davis_Hyer\",\n" +
      "         \"father\":\"Blaine_McGary\",\n" +
      "         \"mother\":\"Betty_White\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Davis\",\n" +
      "         \"lastName\":\"Hyer\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Davis_Hyer\",\n" +
      "         \"spouse\":\"Sheila_Parker\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Blaine\",\n" +
      "         \"lastName\":\"McGary\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Blaine_McGary\",\n" +
      "         \"father\":\"Ken_Rodham\",\n" +
      "         \"mother\":\"Mrs_Rodham\",\n" +
      "         \"spouse\":\"Betty_White\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Betty\",\n" +
      "         \"lastName\":\"White\",\n" +
      "         \"gender\":\"f\",\n" +
      "         \"personID\":\"Betty_White\",\n" +
      "         \"father\":\"Frank_Jones\",\n" +
      "         \"mother\":\"Mrs_Jones\",\n" +
      "         \"spouse\":\"Blaine_McGary\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Ken\",\n" +
      "         \"lastName\":\"Rodham\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Ken_Rodham\",\n" +
      "         \"spouse\":\"Mrs_Rodham\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Mrs\",\n" +
      "         \"lastName\":\"Rodham\",\n" +
      "         \"gender\":\"f\",\n" +
      "         \"personID\":\"Mrs_Rodham\",\n" +
      "         \"spouse\":\"Ken_Rodham\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Frank\",\n" +
      "         \"lastName\":\"Jones\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Frank_Jones\",\n" +
      "         \"spouse\":\"Mrs_Jones\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Mrs\",\n" +
      "         \"lastName\":\"Jones\",\n" +
      "         \"gender\":\"f\",\n" +
      "         \"personID\":\"Mrs_Jones\",\n" +
      "         \"spouse\":\"Frank_Jones\",\n" +
      "         \"descendant\":\"sheila\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Patrick\",\n" +
      "         \"lastName\":\"Spencer\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Patrick_Spencer\",\n" +
      "         \"descendant\":\"patrick\",\n" +
      "         \"father\":\"Happy_Birthday\",\n" +
      "         \"mother\":\"Golden_Boy\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Patrick\",\n" +
      "         \"lastName\":\"Wilson\",\n" +
      "         \"gender\":\"m\",\n" +
      "         \"personID\":\"Happy_Birthday\",\n" +
      "         \"descendant\":\"patrick\",\n" +
      "         \"spouse\":\"Golden_Boy\"\n" +
      "      },\n" +
      "      {\n" +
      "         \"firstName\":\"Spencer\",\n" +
      "         \"lastName\":\"Seeger\",\n" +
      "         \"gender\":\"f\",\n" +
      "         \"personID\":\"Golden_Boy\",\n" +
      "         \"descendant\":\"patrick\",\n" +
      "         \"spouse\":\"Happy_Birthday\"\n" +
      "      }\n" +
      "   ]" + "}";

  getMockEventData() {
    return EventsResponse.fromJson(jsonDecode(eventData));
  }

  getMockPeopleData() {
    return PersonsResponse.fromJson(jsonDecode(peopleData));
  }
}