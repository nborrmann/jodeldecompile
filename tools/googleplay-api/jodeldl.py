#!/usr/bin/python2

import sys
import urlparse
import code
from pprint import pprint
from google.protobuf import text_format

from config import *
from googleplay import GooglePlayAPI
import os
import requests

api = GooglePlayAPI(ANDROID_ID)
api.login(GOOGLE_LOGIN, GOOGLE_PASSWORD, AUTH_TOKEN)

package_name = "com.tellm.android.app"

r = api.details(package_name)
version = r.docV2.details.appDetails.versionString
date = r.docV2.details.appDetails.uploadDate
version_code = r.docV2.details.appDetails.versionCode
file_size = r.docV2.details.appDetails.installationSize

print "current version is ", version, "published on ",  date
f_name = "/root/jodeldecompile/apks/com.tellm.android.app-%s.apk" % version

if os.path.isfile(f_name) and os.path.getsize(f_name) == file_size:
    print "already downloaded"
else:
    print "downloading apk to %s" % f_name
    
    data = api.download(package_name, version_code)
    with open(f_name, "wb") as f:
        f.write(data)
    
    if len(data) != file_size:
        print("WARNING: file sizes don't match. downloaded %d, should be %d" % (len(data), file_size))
    else:
        print "written %d bytes" % len(data)
