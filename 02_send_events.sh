# this will send the following event twice,
# first will be correctly enriched with sessionid and trackingid cookies
# while the second will not, even though the sessionid is present in the cookie header

# {
#     "schema":"iglu:com.snowplowanalytics.snowplow/unstruct_event/jsonschema/1-0-0",
#     "data": {
#         "schema": "iglu:com.google.ga4/first_visit/jsonschema/1-0-0",
#         "data": {}
#     }
# }


PAYLOAD_TEMPLATE='{"schema":"iglu:com.snowplowanalytics.snowplow/payload_data/jsonschema/1-0-4","data":[{"e":"ue","eid":"###EVENTID###","tv":"js-3.13.1","tna":"spTracker","aid":"curly","p":"web","cookie":"1","cs":"UTF-8","lang":"en-GB","res":"3440x1440","cd":"24","tz":"Europe/Berlin","dtm":"###TIMESTAMP###","ue_px":"ewogICAgInNjaGVtYSI6ImlnbHU6Y29tLnNub3dwbG93YW5hbHl0aWNzLnNub3dwbG93L3Vuc3RydWN0X2V2ZW50L2pzb25zY2hlbWEvMS0wLTAiLAogICAgImRhdGEiOiB7CiAgICAgICAgInNjaGVtYSI6ICJpZ2x1OmNvbS5nb29nbGUuZ2E0L2ZpcnN0X3Zpc2l0L2pzb25zY2hlbWEvMS0wLTAiLAogICAgICAgICJkYXRhIjoge30KICAgIH0KfQ==","vp":"921x1275","ds":"921x5416","vid":"1","sid":"99e1222f-f0f5-477d-b82d-92a36f19074f","url":"https://www.idealo.de/","stm":"###TIMESTAMP###"}]}'

# Working event
TIMESTAMP=$(date +%s)000
PAYLOAD=$(echo $PAYLOAD_TEMPLATE | sed "s/###TIMESTAMP###/$TIMESTAMP/g" | sed "s/###EVENTID###/$(uuidgen)/g")

curl 'http://localhost:9090/com.snowplowanalytics.snowplow/tp2' \
  -H 'content-type: application/json' \
  -H 'Cookie: wanted_cookie=crucial_value; AS_JSON={\"Key\":"Value"};' \
  -H 'origin: https://www.idealo.de' \
  -H 'referer: https://www.idealo.de/' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0' \
  --data-raw $PAYLOAD

sleep 1

# Broken event
TIMESTAMP=$(date +%s)000
PAYLOAD=$(echo $PAYLOAD_TEMPLATE | sed "s/###TIMESTAMP###/$TIMESTAMP/g" | sed "s/###EVENTID###/$(uuidgen)/g")

curl 'http://localhost:9090/com.snowplowanalytics.snowplow/tp2' \
  -H 'content-type: application/json' \
  -H 'Cookie: AS_JSON={\"Key\":"Value"}; wanted_cookie=crucial_value;' \
  -H 'origin: https://www.idealo.de' \
  -H 'referer: https://www.idealo.de/' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0' \
  --data-raw $PAYLOAD
