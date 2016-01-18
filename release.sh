#/bin/sh
curl --data '{"tag_name": "v0.0.1"}' https://api.github.com/repos/Erdwolf/scala-on-circle/releases?access_token=$GITHUB_TOKEN > response.json
cat response.json
release_id=`python -c 'import json; print json.load("reponse.json")["id"]'`
curl -T `find target -name "*.jar"` https://api.github.com/repos/Erdwolf/scala-on-circle/releases/$release_id/assets?name=naked.jar
