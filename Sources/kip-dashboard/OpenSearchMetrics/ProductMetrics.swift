//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/28/23.
//

import Dependencies
import Foundation
import JSON

struct ProductMetrics {
    static let locationFilterToRemoveTestingStores = """
          "must_not": [
            {
              "match_phrase": {
                "locationId.keyword": "LKA2D3148RFDC"
              }
            },
            {
              "match_phrase": {
                "locationId.keyword": "LRFMGA54WSD4E"
              }
            },
            {
              "match_phrase": {
                "locationId.keyword": "LGFRKXEFPBDVA"
              }
            }
          ]
        """
    
    static func averageItemData(
        startDate inStartDate: Date? = nil,
                          endDate inEndDate: Date? = nil) async throws -> JSON {
        let startDate: Date
        let endDate: Date
        if let inStartDate {
            startDate = inStartDate
        } else {
            startDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .backward)
                .unwrapped()
                .rawStartOfDay - 12.weeks
        }
        if let inEndDate {
            endDate = inEndDate
        } else {
            endDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .forward)
                .unwrapped()
                .startOfDay
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
        {
          "aggs": {
            "totalCost": {
              "sum": {
                "field": "totalCost"
              }
            },
            "averageOrderValue": {
              "avg": {
                "field": "totalCost"
              }
            },
            "claimedToCompletion": {
              "avg": {
                "field": "claimedToCompletion"
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
                  "match_all": {
                    
                  }
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
              \(locationFilterToRemoveTestingStores)
            }
          }
        }
        """
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func averageOrderData(
        startDate inStartDate: Date? = nil,
                          endDate inEndDate: Date? = nil) async throws -> JSON {
        let startDate: Date
        let endDate: Date
        if let inStartDate {
            startDate = inStartDate
        } else {
            startDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .backward)
                .unwrapped()
                .rawStartOfDay - 12.weeks
        }
        if let inEndDate {
            endDate = inEndDate
        } else {
            endDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .forward)
                .unwrapped()
                .startOfDay
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*orders-prod"
        let query = """
        {
          "aggs": {
            "totalCost": {
              "sum": {
                "field": "totalCost"
              }
            },
            "averageOrderValue": {
              "avg": {
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
                  "match_all": {
                    
                  }
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
              \(locationFilterToRemoveTestingStores)
            }
          }
        }
        """
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    static func orderData(startDate inStartDate: Date? = nil,
                          endDate inEndDate: Date? = nil) async throws -> JSON {
        let startDate: Date
        let endDate: Date
        if let inStartDate {
            startDate = inStartDate
        } else {
            startDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .backward)
                .unwrapped()
                .rawStartOfDay - 12.weeks
        }
        if let inEndDate {
            endDate = inEndDate
        } else {
            endDate = try Date()
                .moveToDayOfWeek(.sunday, direction: .forward)
                .unwrapped()
                .startOfDay
        }
        
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
                "averageOrderValue": {
                  "avg": {
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
              \(locationFilterToRemoveTestingStores)
            }
          }
        }
        """
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func itemModificationData(
        modified: Bool = false,
        startDate startDateIn: Date? = nil,
        endDate endDateIn: Date? = nil) async throws -> JSON {
            
            let startDate = try startDateIn ?? (Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks)
            let endDate =  try endDateIn ?? (Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay)
            
            let mustNot: String
            if modified {
                mustNot = """
                "must_not": [
                        {
                          "match_phrase": {
                            "modifierCount": "0"
                          }
                        },
                        {
                          "match_phrase": {
                            "locationId.keyword": "LKA2D3148RFDC"
                          }
                        },
                        {
                          "match_phrase": {
                            "locationId.keyword": "LRFMGA54WSD4E"
                          }
                        },
                        {
                          "match_phrase": {
                            "locationId.keyword": "LGFRKXEFPBDVA"
                          }
                        }
                      ]
            """
            } else {
                mustNot = """
              "must_not": [
                {
                  "match_phrase": {
                    "locationId.keyword": "LKA2D3148RFDC"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LRFMGA54WSD4E"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LGFRKXEFPBDVA"
                  }
                }
              ]
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
            let result = try await makeRequest(query: query, index: index)
            return result
        }
    
    static func itemModificationDataSummary(modified: Bool = false, startDate startDateIn: Date? = nil, endDate endDateIn: Date? = nil) async throws -> JSON {
        
        let startDate = try startDateIn ?? (Date().moveToDayOfWeek(.sunday, direction: .backward).unwrapped().rawStartOfDay - 12.weeks)
        let endDate =  try endDateIn ?? (Date().moveToDayOfWeek(.sunday, direction: .forward).unwrapped().startOfDay)
        
        let mustNot: String
        if modified {
            mustNot = """
                "must_not": [
                        {
                          "match_phrase": {
                            "modifierCount": "0"
                          }
                        },
                        {
                          "match_phrase": {
                            "locationId.keyword": "LKA2D3148RFDC"
                          }
                        },
                            {
                              "match_phrase": {
                                "locationId.keyword": "LRFMGA54WSD4E"
                              }
                            },
                        {
                          "match_phrase": {
                            "locationId.keyword": "LGFRKXEFPBDVA"
                          }
                        }
                      ]
            """
        } else {
            mustNot = """
              "must_not": [
                {
                  "match_phrase": {
                    "locationId.keyword": "LKA2D3148RFDC"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LRFMGA54WSD4E"
                  }
                },
                {
                  "match_phrase": {
                    "locationId.keyword": "LGFRKXEFPBDVA"
                  }
                }
              ]
            """
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
        {
          "aggs": {
            "modifierCountAverage": {
              "avg": {
                "field": "modifierCount"
              }
            }
          },
            "size": 0,
            "track_total_hits": true,
            "stored_fields": [
              "*"
            ],
            "script_fields": {},
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
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func itemData( startDate: Date, endDate: Date) async throws -> JSON {
        
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
                },
                "cost": {
                  "avg": {
                    "field": "cost"
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
                \(locationFilterToRemoveTestingStores)
            }
          }
        }
        """
        var result = try await makeRequest(query: query, index: index)
        result["Dates"] = json {
            [
                "startDate": "\(dateFormatter.string(from: startDate))",
                "endDate": "\(dateFormatter.string(from: endDate))",
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
                },
                "objectId": {
                  "top_hits": {
                      "_source": "catalogId",
                      "size": 1,
                      "sort": [
                        {
                          "placedAt": {
                            "order": "desc"
                          }
                        }
                      ]
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
              \(locationFilterToRemoveTestingStores)
            }
          }
        }
        """
        return try await makeRequest(query: query, index: index)
    }
    
    static func storeOrders(locationId: String?, startDate: Date, endDate: Date = Date()) async throws -> JSON {
        
        let locationFilter: String
        if let locationId {
            locationFilter = """
            {
              "match_phrase": {
                 "locationId.keyword": "\(locationId)"
              }
            },
            """
        } else {
            locationFilter = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*orders-prod"
        let query = """
        {
           "aggs": {
            "AOV": {
                "avg":{
                   "field": "totalCost"
                    }
                },
              "3": {
                "avg_bucket": {
                  "buckets_path": "3-bucket>_count"
                }
              },
              "3-bucket": {
                "date_histogram": {
                  "field": "placedAt",
                  "calendar_interval": "1w",
                  "time_zone": "America/Los_Angeles",
                  "min_doc_count": 1
                }
              }
            },
          "size": 0,
          "track_total_hits": true,
         "stored_fields": [
            "*"
          ],
          "script_fields": {},
          "_source": {
            "excludes": []
          },
          "docvalue_fields": [
            {
              "field": "placedAt",
              "format": "date_time"
            }
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
                \(locationFilter)
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
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func storeOrderValue(locationId: String?, startDate: Date, endDate: Date = Date()) async throws -> JSON {
        
        let locationFilter: String
        if let locationId {
            locationFilter = """
            {
              "match_phrase": {
                 "locationId.keyword": "\(locationId)"
              }
            },
            """
        } else {
            locationFilter = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*orders-prod"
        let query = """
        {
           "aggs": {
                "sales": {
                    "sum": {
                        "field": "totalCost"
                     }
                }
            },
          "size": 0,
          "track_total_hits": true,
         "stored_fields": [
            "*"
          ],
          "script_fields": {},
          "_source": {
            "excludes": []
          },
          "docvalue_fields": [
            {
              "field": "placedAt",
              "format": "date_time"
            }
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
                \(locationFilter)
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
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func storeItems(locationId: String?, startDate: Date, endDate: Date = Date()) async throws -> JSON {
        let locationFilter: String
        if let locationId {
            locationFilter = """
            {
              "match_phrase": {
                 "locationId.keyword": "\(locationId)"
              }
            },
            """
        } else {
            locationFilter = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let index = "*-lineitems-prod"
        let query = """
        {
           "aggs": {
            "cost": {
                "avg":{
                    "field": "cost"
                }
            }
        },
          "size": 0,
          "track_total_hits": true,
         "stored_fields": [
            "*"
          ],
          "script_fields": {},
          "_source": {
            "excludes": []
          },
          "docvalue_fields": [
            {
              "field": "placedAt",
              "format": "date_time"
            }
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
                \(locationFilter)
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
        let result = try await makeRequest(query: query, index: index)
        return result
    }
    
    static func makeRequest(query: String, index: String) async throws -> JSON {
        @Dependency(\.configuration) var config
        @Dependency(\.httpClient) var client
        let loginString = String(format: "%@:%@", config.openSearchUsername, config.openSearchPassword)
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            throw ServiceError("unable to get username and password")
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        let endpoint = Endpoint(
            method: .POST,
            path: config.openSearchEndpoint + "/\(index)/_search",
            headers: [
                "Authorization": "Basic \(base64LoginString)",
                "Content-Type": "application/json; charset=utf-8",
            ],
            body: query.asData
        )
        
        let source = try await client.request(endpoint)
            .decode(type: JSON.self)
            .get()
        return source
    }
}
