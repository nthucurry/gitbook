{
  "query": {
    "regexp": {
      "destinationIP": "10.<0-255>.<0-255>.<0-255>|172.17.<0-255>.<0-255>"
    }
  }
}

{
  "query": {
    "bool": {
      "should": [
        {
          "regexp": {
            "sourceIP": "10.<0-255>.<0-255>.<0-255>|172.17.<0-255>.<0-255>"
          }
        },
        {
          "regexp": {
            "destinationIP": "10.<0-255>.<0-255>.<0-255>|172.17.<0-255>.<0-255>"
          }
        }
      ],
      "minimum_should_match": 2
    }
  }
}