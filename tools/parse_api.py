#!/usr/bin/python3

import re
from pprint import pprint
import sys

if len(sys.argv) < 2:
    print("enter version number as parameter")
    exit()

version = sys.argv[1]
directory = "jodel-{}/jd/com/jodelapp/jodelandroidv3/api/".format(version)
print("using directory {}".format(directory))

f = open("api_{}.py".format(version), "w")
sys.stdout = f

def snake_case(name=""):
    if not name:
        return ""

    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

with open(directory + "JodelApi.java", "r") as f:
    data = f.read()

re_endpoint = re.compile('  @(?P<method>[A-Z]+)\(\"(?P<url>.+)\"\)\n  public abstract Observable<\w*> (?P<name>\w+)\((?P<params>.*)\);')
re_params = re.compile('@(?P<type>\w+)(\(\"(?P<name>\w+)\"\))? (?P<class>.*?) param\w+')
re_body_param = re.compile('  (?:public|private)(?: final)?(?! transient) (?P<class>[^ ]+) (?P<name>[^ ]+);')
matches = [m.groupdict() for m in re_endpoint.finditer(data)]

for match in matches:
    match["name"] = snake_case(match["name"])
    match["params"] = [m.groupdict() for m in re_params.finditer(match.get("params", ''))]

def parse_body(filename):
    try:
        with open(directory + "model/{}.java".format(filename), "r") as f:
            data = f.read()
    except:
        return []

    matches = [m.groupdict() for m in re_body_param.finditer(data)]
    for match in matches:
        match["name"] = snake_case(match["name"])
    return matches

for match in matches:
    param_string = ""
    url_params = []
    query_params = []
    body_params = ""

    for param in match["params"]:
        if param["type"] == "Path":
            name = snake_case(param["name"])
            param_string += "{}, ".format(name)
            match["url"] = match["url"].replace("{{{}}}".format(param["name"]), "{}")
            url_params.append(name)

        elif param["type"] == "Query":
            name = snake_case(param["name"])
            param_string += "{name}, ".format(name=name)
            query_params.append(name)

        elif param["type"] == "Body" and param["class"] != "Object":
            body_params = parse_body(param["class"])
            for param in body_params:
                param_string += "{name}, ".format(**param)


    if url_params:
        url_params = ".format({})".format(", ".join("{name}".format(name=name) for name in url_params))
    else:
        url_params = ""

    if query_params:
        query_params = ", params={{{}}}".format(", ".join("\"{name}\": {name}".format(name=name) for name in query_params))
    else:
        query_params = ""

    if body_params:
        body_params = ", payload={{{}}}".format(", ".join("\"{name}\": {name}".format(**param) for param in body_params))
    else:
        body_params = ""

    print("def {name}(self, {param_string}**kwargs):".format(param_string=param_string, **match))
    print("    return self._send_request(\"{method}\", \"{url}\"{url_params}{query_params}{body_params}, **kwargs)"
        .format(url_params=url_params, query_params=query_params, body_params=body_params, **match))
    print("")


f.close()
