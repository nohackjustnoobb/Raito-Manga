import json
import os
from pathlib import Path
import random
import string

try:
    with open("/config.json", "r") as file:
        config = json.load(file)
except:
    config = {}


# generate the secret key if not provided
sync = config.get("sync", {})
secretKey = sync.get("secretKey")

if secretKey is None:
    secretKey = "".join(
        random.SystemRandom().choice(string.ascii_letters + string.digits)
        for _ in range(128)
    )

    sync["secretKey"] = secretKey
    config["sync"] = sync

    with open("/config.json", "w") as file:
        json.dump(config, file, indent=4)

# Update the config
api = config.get("api", {})

server = api.get("server", {})
server["baseUrl"] = "/api/"
server["webpageUrl"] = "/"
api["server"] = server

driver = api.get("driver", {})
if driver.get("include") is None and driver.get("exclude") is None:
    driver["exclude"] = ["MHG"]
    api["driver"] = driver


config["api"] = api

# split the config into corresponding components
apiConfig = config.get("api", {})
syncConfig = config.get("sync", {})


# write the config
with open("/app/api/config.json", "w+") as file:
    json.dump(apiConfig, file)


with open("/app/sync/config.json", "w+") as file:
    json.dump(syncConfig, file)


# create the file if not exists
Path("/data/api/data").mkdir(parents=True, exist_ok=True)
Path("/data/api/image").mkdir(parents=True, exist_ok=True)

Path("/data/sync").mkdir(parents=True, exist_ok=True)
Path("/data/sync/db.sqlite3").touch(mode=0o777, exist_ok=True)

# link the folder/file to the mounted folder/file
try:
    os.symlink("/data/api/data", "/app/api/data", target_is_directory=True)
    os.symlink("/data/api/image", "/app/api/image", target_is_directory=True)
    os.symlink(
        "/data/sync/db.sqlite3", "/app/sync/db.sqlite3", target_is_directory=True
    )
except FileExistsError:
    pass
