//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/28/23.
//

import Foundation
import Dependencies
import JSON


struct ProductMetrics {
    static func orderData() async throws -> JSON {
        let startDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks
        let endDate = try Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay
       
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*orders-prod"
        let query = """
{
  "aggs": {
    "orders": {
      "date_histogram": {
        "field": "createdAt",
        "calendar_interval": "1w",
        "time_zone": "America/Los_Angeles",
        "min_doc_count": 1
      },
        "aggs": {
        "totalCost": {
          "sum": {
            "field": "totalCost"
          }
        },
        "itemCount": {
          "sum": {
            "field": "itemCount"
          }
        },
        "avgItemCount": {
          "avg": {
            "field": "itemCount"
          }
        },
        "placedToCompletion": {
          "avg": {
            "field": "placedToCompletion"
          }
        },
        "modifierCount": {
          "avg": {
            "field": "lineItems.modifierCount"
          }
        }
      }
    }
  },
  "size": 0,
  "stored_fields": [
    "*"
  ],
  "query": {
    "bool": {
      "must": [],
      "filter": [
        {
          "match_all": {}
        },
        {
          "match_phrase": {
            "state": "completed"
          }
        },
        {
          "range": {
            "placedAt": {
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
        let result =  try await makeRequest(query: query, index: index)
        return result
    }
    
    
    static func itemModificationData(modified: Bool = false) async throws -> JSON {
        let startDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks
        let endDate = try Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay
       
        let mustNot: String
        if modified {
            mustNot = """
            "must_not": [
                    {
                      "match_phrase": {
                        "modifierCount": "0"
                      }
                    }
                  ]
        """
        } else {
            mustNot = """
        "must_not": []
        """
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
{
  "aggs": {
    "items": {
      "date_histogram": {
        "field": "placedAt",
        "calendar_interval": "1w",
        "time_zone": "America/Los_Angeles",
        "min_doc_count": 1
      }
    }
  },
  "size": 0,
  "query": {
    "bool": {
      "must": [],
      "filter": [
        {
          "match_all": {}
        },
        {
          "match_phrase": {
            "state": "completed"
          }
        },
        {
          "range": {
            "placedAt": {
              "gte": "\(dateFormatter.string(from: startDate))",
              "lte": "\(dateFormatter.string(from: endDate))",
              "format": "strict_date_optional_time"
            }
          }
        }
      ],
      "should": [],
      \(mustNot)
    }
  }
}
"""
        let result =  try await makeRequest(query: query, index: index)
        return result
    }
    
    static func itemData() async throws -> JSON {
        let startDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks
        let endDate = try Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay
       
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
{
  "aggs": {
    "orders": {
      "date_histogram": {
        "field": "placedAt",
        "calendar_interval": "1w",
        "time_zone": "America/Los_Angeles",
        "min_doc_count": 1
      },
      "aggs": {
        "claimedToCompletion": {
          "avg": {
            "field": "claimedToCompletion"
          }
        },
        "placedToCompletion": {
          "avg": {
            "field": "placedToCompletion"
          }
        },
        "modifierCount": {
          "avg": {
            "field": "modifierCount"
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
      "field": "canceledAt",
      "format": "date_time"
    },
    {
      "field": "completedAt",
      "format": "date_time"
    },
    {
      "field": "inProgressAt",
      "format": "date_time"
    },
    {
      "field": "orderSessionStartedAt",
      "format": "date_time"
    },
    {
      "field": "placedAt",
      "format": "date_time"
    },
    {
      "field": "placedAtPacificDate",
      "format": "date_time"
    },
    {
      "field": "recalledAt",
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
            "state": "completed"
          }
        },
        {
          "range": {
            "placedAt": {
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
        var result =  try await makeRequest(query: query, index: index)
        result["Dates"] = json {
            [
            "startDate": "\(dateFormatter.string(from: startDate))",
            "endDate": "\(dateFormatter.string(from: endDate))"
            ]
            }
        return result
    }
    
    static func productTable() async throws -> JSON {
        let startDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks
        let endDate = try Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay
       
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
{
  "aggs": {
    "products": {
      "terms": {
        "field": "name.keyword",
        "order": {
          "_count": "desc"
        },
        "size": 45
      },
      "aggs": {
        "modifierCount": {
          "avg": {
            "field": "modifierCount"
          }
        },
        "cost": {
          "avg": {
            "field": "cost"
          }
        },
        "placedToCompletion": {
          "avg": {
            "field": "placedToCompletion"
          }
        },
        "claimedToCompletion": {
          "avg": {
            "field": "claimedToCompletion"
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
      "field": "canceledAt",
      "format": "date_time"
    },
    {
      "field": "completedAt",
      "format": "date_time"
    },
    {
      "field": "inProgressAt",
      "format": "date_time"
    },
    {
      "field": "orderSessionStartedAt",
      "format": "date_time"
    },
    {
      "field": "placedAt",
      "format": "date_time"
    },
    {
      "field": "placedAtPacificDate",
      "format": "date_time"
    },
    {
      "field": "recalledAt",
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
            "state": "completed"
          }
        },
        {
          "range": {
            "placedAt": {
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
        return try await makeRequest(query: query, index: index)
    }
    
    
    static func makeRequest(query: String, index: String) async throws -> JSON {
        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var  client
        let loginString =  String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8"
            ],
            body: query.asData
        )
        
        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()
        return source
    
    }
    
}
