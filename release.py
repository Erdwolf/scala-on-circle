import requests, os, sys, json

AUTH_HEADER = {"Authorization": "token "+os.getenv('GITHUB_TOKEN')}
BUILD_NUM = "Z"#+os.getenv('CIRCLE_BUILD_NUM')

print "Creating release..."
print
request=json.dumps({
  "tag_name": "build-"+BUILD_NUM,
  "name":     "Build #"+BUILD_NUM,
  "body":     "Automatically released after successful build.",
})
print request

r=requests.post('https://api.github.com/repos/Erdwolf/scala-on-circle/releases',
                headers=AUTH_HEADER,
                data=request)

print "HTTP Code: {}".format(r.status_code)

# Assert response code
if r.status_code != 201:
    print r.text
    sys.exit(1)

# Pretty-print the response
print json.dumps(r.json(), indent=2)

upload_url = r.json()["upload_url"].format(**{"?name,label": ""})


print
print "Uploading asset to {}...".format(upload_url)
print
headers = {"Content-Type": "application/java-archive"}
headers.update(AUTH_HEADER)
r=requests.post(upload_url+'?name='+'foo.jar',
                headers=headers,
                data=file(sys.argv[1],'rb'))

print "HTTP Code: {}".format(r.status_code)

# Assert response code
if r.status_code != 201:
    print r.text
    sys.exit(1)

# Pretty-print the response
print json.dumps(r.json(), indent=2)
