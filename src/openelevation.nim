import asyncdispatch, httpclient, json, strutils, uri

const api = "https://api.open-elevation.com/api/v1"
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    "Host": "api.open-elevation.com",
    "Accept": "application/json",
    "Content-Type": "application/json"
})

proc get_elevation*(latitude: float, longitude: float): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let body = %*{"locations": [{"latitude": latitude, "longitude": longitude}]}
    let response = await client.post(api & "/lookup", $body)
    let responseBody = await response.body
    result = parseJson(responseBody)
  finally:
    client.close()

proc get_elevations*(locations: seq[tuple[latitude: float, longitude: float]]): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    var locations_json = newJArray()
    for loc in locations:
      locations_json.add(%*{"latitude": loc.latitude, "longitude": loc.longitude})
    
    let body = %*{"locations": locations_json}
    let response = await client.post(api & "/lookup", $body)
    let responseBody = await response.body
    result = parseJson(responseBody)
  finally:
    client.close()
