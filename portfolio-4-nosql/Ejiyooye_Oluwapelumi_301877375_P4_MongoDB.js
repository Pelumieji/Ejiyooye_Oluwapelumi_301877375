// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("order_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("order_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "order_placed",
                    "item_added"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "order_item"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "order_item_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("order_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_placed",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "order_item",
            "key": {
                "order_item_id": 4
            },
            "snapshot": {
                "order_item_id": 4,
                "order_id": 3,
                "product_id": 2,
                "quantity": 2,
                "unit_price": 11.5
            }
        },
        "embedded": {
            "customer": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "email": "alex@example.test",
                        "display_name": "Alex Customer",
                        "created_at": "2026-01-10T09:30:00Z"
                    },
                    "via": [
                        "order_item.order_id → order_header.customer_id → customer"
                    ]
                }
            ]
        },
        "references": {
            "order_header": [
                {
                    "key": {
                        "order_id": 3
                    },
                    "via": [
                        "order_item.order_id → order_header"
                    ]
                }
            ],
            "product": [
                {
                    "key": {
                        "product_id": 2
                    },
                    "via": [
                        "order_item.product_id → product"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "item_added",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "order_item",
            "key": {
                "order_item_id": 4
            },
            "snapshot": {
                "order_item_id": 4,
                "order_id": 3,
                "product_id": 2,
                "quantity": 2,
                "unit_price": 11.5
            }
        },
        "embedded": {
            "customer": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "email": "alex@example.test",
                        "display_name": "Alex Customer",
                        "created_at": "2026-01-10T09:30:00Z"
                    },
                    "via": [
                        "order_item.order_id → order_header.customer_id → customer"
                    ]
                }
            ]
        },
        "references": {
            "order_header": [
                {
                    "key": {
                        "order_id": 3
                    },
                    "via": [
                        "order_item.order_id → order_header"
                    ]
                }
            ],
            "product": [
                {
                    "key": {
                        "product_id": 2
                    },
                    "via": [
                        "order_item.product_id → product"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "payment_reference": "illustrative payment_reference",
                "tracking_code": "illustrative tracking_code",
                "discount_details": "illustrative discount_details",
                "failure_reason": "illustrative failure_reason"
            }
        }
    }
]));
  await db.getCollection("order_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("order_events").find({"source.key.order_item_id":4}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("order_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_item",
        "key": {
            "order_item_id": 4
        },
        "snapshot": {
            "order_item_id": 4,
            "order_id": 3,
            "product_id": 2,
            "quantity": 2,
            "unit_price": 11.5
        }
    },
    "embedded": {
        "customer": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "email": "alex@example.test",
                    "display_name": "Alex Customer",
                    "created_at": "2026-01-10T09:30:00Z"
                },
                "via": [
                    "order_item.order_id → order_header.customer_id → customer"
                ]
            }
        ]
    },
    "references": {
        "order_header": [
            {
                "key": {
                    "order_id": 3
                },
                "via": [
                    "order_item.order_id → order_header"
                ]
            }
        ],
        "product": [
            {
                "key": {
                    "product_id": 2
                },
                "via": [
                    "order_item.product_id → product"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("order_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_item",
        "key": {
            "order_item_id": 4
        },
        "snapshot": {
            "order_item_id": 4,
            "order_id": 3,
            "product_id": 2,
            "quantity": 2,
            "unit_price": 11.5
        }
    },
    "embedded": {
        "customer": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "email": "alex@example.test",
                    "display_name": "Alex Customer",
                    "created_at": "2026-01-10T09:30:00Z"
                },
                "via": [
                    "order_item.order_id → order_header.customer_id → customer"
                ]
            }
        ]
    },
    "references": {
        "order_header": [
            {
                "key": {
                    "order_id": 3
                },
                "via": [
                    "order_item.order_id → order_header"
                ]
            }
        ],
        "product": [
            {
                "key": {
                    "product_id": 2
                },
                "via": [
                    "order_item.product_id → product"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("order_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
