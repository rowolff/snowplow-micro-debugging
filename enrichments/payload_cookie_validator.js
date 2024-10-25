function process(event) {
  let wantedCookieValue;

  const entities = JSON.parse(event.getDerived_contexts());

  if (entities) {
    for (const entity of entities.data) {
      const isCookieSchema = entity.schema.startsWith(
        "iglu:org.ietf/http_cookie/jsonschema/1"
      );
      const isWantedCookie = entity.data.name === "wanted_cookie";
      if (isCookieSchema && isWantedCookie) {
        wantedCookieValue = entity.data.value;
        break;
      }
    }
  }

  if (!wantedCookieValue) {
    throw "No cookie :'(";
  }
}
