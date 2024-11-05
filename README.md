# README

The application can receive GraphQL requests to store stock quotes (consisting of a ticker, timestamp and price) in a database.

When receiving a new request, a new quote related to the given ticker is created. If the given ticker doesn't exist yet in the database, it gets created. If the request would create a quote with a timestamp and ticker pair that already exists, it modifies that quote instead.

The GraphQL API is automatically documented by GraphiQL

---

The database schema is as follows:

![The db schema](https://github.com/Igno-C/RoRTask/blob/master/gram.png?raw=true)
