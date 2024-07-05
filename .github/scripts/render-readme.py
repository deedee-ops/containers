import os
import json
import requests
import yaml

from jinja2 import Environment, PackageLoader, select_autoescape

env = Environment(
    loader=PackageLoader("render-readme"),
    autoescape=select_autoescape()
)

def load_metadata_file_yaml(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def load_metadata_file_json(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def load_metadata_file(file_path):
    if file_path.endswith(".json"):
        return load_metadata_file_json(file_path)
    elif file_path.endswith(".yaml"):
        return load_metadata_file_yaml(file_path)
    return None

def get_latest_image(owner, name):
    r = requests.get(
        f"https://api.github.com/users/{owner}/packages/container/{name}/versions",
        headers={
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token " + os.environ["GITHUB_TOKEN"]
        },
    )
    if r.status_code != 200:
        print(f"Failed to get versions for {name}: {r.status_code}: {r.text}")
        return None
    data = r.json()
    for image in data:
        tags = image["metadata"]["container"]["tags"]
        if "latest" in tags:
            return image
    print(f"Couldn't find latest tag for {name}")
    return None

if __name__ == "__main__":
    base_images = []
    app_images = []
    owner = os.environ["GITHUB_REPOSITORY_OWNER"]
    for subdir, dirs, files in os.walk("./apps"):
        for file in files:
            if file != "metadata.yaml" and file != "metadata.json":
                continue
            meta = load_metadata_file(os.path.join(subdir, file))
            for channel in meta["channels"]:
                name = ""
                if channel["name"] == "stable":
                    name = meta["app"]
                else:
                    name = "-".join([meta["app"], channel["name"]])
                image = {
                    "name": name,
                    "insecure": False,
                    "channel": channel["name"],
                    "html_url": ""
                }
                if meta.get("insecure"):
                    image["insecure"] = True
                gh_data = get_latest_image(owner, name)
                if gh_data is not None:
                    image["html_url"] = f"https://github.com/{owner}/containers/pkgs/container/{name}"
                    image["tags"] = sorted(gh_data["metadata"]["container"]["tags"])
                if meta["base"]:
                    base_images.append(image)
                else:
                    app_images.append(image)

    template = env.get_template("README.md.j2")
    with open("./README.md", "w") as f:
        f.write(template.render(base_images=base_images, app_images=app_images))
