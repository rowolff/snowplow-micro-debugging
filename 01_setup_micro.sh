docker run -p 9090:9090 \
  --mount type=bind,source=$(pwd)/enrichments,destination=/config/enrichments \
  snowplow/snowplow-micro:2.1.2