#/bin/sh
asset_path="$1"
[ -n "$asset_path" -a -f $asset_path ] || {
  echo "asset path '$asset_path' not found!"
  exit 1
}

auth_header="Authorization: token $GITHUB_TOKEN"

echo "Creating release..."
echo
request='{
  "tag_name": "build-'$CIRCLE_BUILD_NUM'",
  "name": "Build #'$CIRCLE_BUILD_NUM'"
}'
echo "$request"
code=`curl --header "$auth_header" \
     --data "$request" \
     https://api.github.com/repos/Erdwolf/scala-on-circle/releases \
     -o response.json \
     -w '%{http_code}'`

echo "HTTP Code: $code"

# Assert response code
[ $code -eq 201 ] || {
  cat response.json
  exit 1
}

# Pretty-print the response
python -m json.tool response.json

upload_url=`python -c 'import json; print json.load(file("response.json"))["upload_url"].format(**{"?name,label": ""})'`


name=`basename $asset_path`
echo
echo "Uploading $asset_name to $upload_url..."
echo

code=`curl --header "$auth_header" \
     --header "Content-Type: application/java-archive" \
     --upload-file "$asset_path" \
     $upload_url?name="$asset_name" \
     -o response.json \
     -w '%{http_code}'`

echo "HTTP Code: $code"

# Assert response code
[ $code -eq 201 ] || {
  cat response.json
  exit 1
}

# Pretty-print the response
python -m json.tool response.json
