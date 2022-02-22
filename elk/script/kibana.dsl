# Private IP
{
  "query": {
    "regexp": {
      "destinationIP": "10.<0-255>.<0-255>.<0-255>|172.17.<0-255>.<0-255>"
    }
  }
}

{
  "query": {
    "match_phrase": {
      "identity.authorization.evidence.role": "Owner"
    }
  }
}

{
  "query": {
    "regexp": {
      "destination": ".*microsoft.com|aka.ms"
    }
  }
}

# Private IP 到 Public IP
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
            "destinationIP": "@&~(10.248.<0-255>.<0-255>)"
          }
        }
      ],
      "minimum_should_match": 2
    }
  }
}