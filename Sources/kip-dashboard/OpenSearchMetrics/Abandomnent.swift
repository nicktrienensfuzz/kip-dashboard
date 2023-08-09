//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 8/8/23.
//

import Dependencies
import Foundation
import JSON

enum Abandonment {
    static func abandonment() async throws -> JSON {
        
        let startDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().startOfDay - 8.weeks
        let endDate = try Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-kiosk-analytics-*"
        
        let query = """
{
  "aggs": {
      "2": {
        "date_histogram": {
          "field": "timestamp",
          "calendar_interval": "1w",
          "time_zone": "America/Los_Angeles",
          "min_doc_count": 1
        },
        "aggs": {
          "location": {
            "significant_terms": {
              "field": "locationId.keyword",
              "size": 20
            },
            "aggs": {
              "outcome": {
                "significant_terms": {
                  "field": "sessionSummary.orderOutcome.keyword",
                  "size": 5
                },
                "aggs": {
                  "7": {
                    "avg": {
                      "field": "elapsedOrderTimeInSession"
                    }
                  }
                }
              },
              "7": {
                "avg": {
                  "field": "elapsedOrderTimeInSession"
                }
              }
            }
          },
          "7": {
            "avg": {
              "field": "elapsedOrderTimeInSession"
            }
          }
        }
      }
    },
  "size": 0,
  "stored_fields": [
    "*"
  ],
  "script_fields": {},
  "docvalue_fields": [
    {
      "field": "orderSessionStartedAt",
      "format": "date_time"
    },
    {
      "field": "timestamp",
      "format": "date_time"
    }
  ],
  "_source": {
    "excludes": []
  },
  "query": {
    "bool": {
      "must": [],
      "filter": [
        {
          "match_all": {}
        },
        {
          "match_phrase": {
            "name": "Event: Order Outcome"
          }
        },
        {
          "match_phrase": {
            "environment": "production"
          }
        },
        {
          "range": {
            "timestamp": {
              "gte": "\(dateFormatter.string(from: startDate))",
              "lte": "\(dateFormatter.string(from: endDate))",
              "format": "strict_date_optional_time"
            }
          }
        }
      ],
      "should": [],
      "must_not": []
    }
  }
}
"""
        
        let data = try await ProductMetrics.makeRequest(query: query, index: index)
        var map = [JSON]()
        try data.aggregations.2.buckets.array.unwrapped().forEach { json in
            var productJ = JSON()
            productJ["date"] = JSON(Date(timeIntervalSince1970: Double((json.key.int ?? 0) / 1000)).formatted("M/dd/yyyy"))
            productJ["count"] = json.doc_count
            
            try json.location.buckets.array.unwrapped().forEach { json in
                productJ["location"] = json.key
                
                try json.outcome.buckets.array.unwrapped().forEach { json in
                    productJ["outcome"] = json.key
                    productJ["avgSession"] = json.7.value
                    map.append( productJ )
                }
            }
        }
        
        return JSON(map)
    }
    
}
