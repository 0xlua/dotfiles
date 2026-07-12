#! /bin/sh

header="Content-Type:application/json"
url="http://deluge:8112/json"
password="$(cat  /run/secrets/deluge_password)"
 
json="{\"method\": \"auth.login\", \"params\": [\"$password\"], \"id\": \"1\"}"
wget -O- -q --header="$header" --post-data="$json" --save-cookies cookies.txt $url

json="{\"method\": \"core.set_config\", \"params\": [{\"listen_ports\": [$1, $1]}], \"id\": \"2\"}"
wget -O- -q --header="$header" --post-data="$json" --load-cookies cookies.txt $url
