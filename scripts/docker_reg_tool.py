#!/usr/bin/python
# ref: https://ops4j.github.io/ramler/0.6.0/registry/
# http://YourPrivateRegistyIP:5000/v2/_catalog
# http://YourPrivateRegistyIP:5000/v2/<name>/tags/list
# curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET http://localhost:5000/v2/<name>/manifests/<tag> 2>&1 | grep Docker-Content-Digest | awk '{print ($3)}'
# curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE http://127.0.0.1:5000/v2/<name>/manifests/sha256:6de813fb93debd551ea6781e90b02f1f93efab9d882a6cd06bbd96a07188b073
import requests
from ast import literal_eval

host = "10.0.15.166:5555"

url = "http://" + host + "/v2/_catalog"
req_obj = requests.get(url)
req_con = req_obj.json()
images_init_lists = req_con.get('repositories')
# print json.dumps(req_con ,indent=4, sort_keys=True)
img_lists = []
for img in images_init_lists:
    tag_url='http://' + host + '/v2/' + img + '/tags/list'
    img_tags = requests.get(tag_url).content
    img_lists.append(img_tags)

print "\n%-36s" % ("\tDOCKER REGISTRY : " + host)
print "%-36s %-10s" % ("==================",  "==================")
print "%-36s %-10s" % ("iamge name",  "image tags")
print "%-36s %-10s" % ("==================",  "==================")

for img_dict in img_lists:
    img_dict = literal_eval(img_dict)
    print "%-36s %-10s" % (img_dict['name'],  img_dict['tags'])


# get Digest
#
# url="http://" + host + "/v2/mariadb/manifests/10.0.23"
# req_obj = requests.get(url)
# hash = req_obj.headers.get('Docker-Content-Digest')
