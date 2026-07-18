#! /bin/sh

url="https://mail.lua.one/jmap"
json="{\"methodCalls\": [[\"x:Action/set\", {\"create\": {\"new1\": {\"@type\": \"ReloadTlsCertificates\" }}}, \"c1\"]],\"using\": [\"urn:ietf:params:jmap:core\", \"urn:stalwart:jmap\"]}"

curl -X POST $url -H "Authorization: Bearer $STALWART_TOKEN" -H "Content-Type: application/json" -d "$json"
