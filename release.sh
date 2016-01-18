#/bin/sh
#curl --data "{\"tag_name\": \"build-$CIRCLE_BUILD_NUM\"}" https://api.github.com/repos/Erdwolf/scala-on-circle/releases?access_token=$GITHUB_TOKEN > response.json
#cat response.json
#release_id=`python -c 'import json; print json.load(file("response.json"))["id"]'`
#echo "Uploading asset for release $release_id..."
curl --header "Content-Type: application/java-archive" --data "blabla" https://uploads.github.com/repos/Erdwolf/scala-on-circle/releases/2448300/assets?name=foo.jar&access_token=$GITHUB_TOKEN
