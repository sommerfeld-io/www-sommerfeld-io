#!/bin/bash
# @file build-and-run-website.sh
# @brief Build a Docker image containing the whole link:https://www.sommerfeld.io[www.sommerfeld.io] website and run locally inside a Docker container.
#
# @description The script automates the process of creating a Docker image that encapsulates
# the entire link:https://www.sommerfeld.io[sommerfeld-io website] within an Apache httpd web
# server and launches it as a container for local testing. The website is built with Antora first.
# This script simplifies the setup and configuration required to run the website locally. The
# image is based on the official link:https://hub.docker.com/_/httpd[Apache httpd] image.
#
# After the image is successfully built, the script launches a Docker container based on the
# newly created image. The container is started in the foreground. The locally hosted website
# can be accessed via a web browser at http://localhost:7888.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# == The webserver image
#
# Per default, Apache httpd runs as ``root`` user because only root processes can listen to ports
# below 1024. The default http port for web applications is 80. But this means the user inside the
# container is ``root`` which poses a potential security risk. And since the webserver is running
# inside a Docker container it is not important what port is used inside the container. So the http
# port is changed to 7888 and the user is switched to the already present user ``www-data``.
#
# Apache is trying to write a file into ``/usr/local/apache2/logs``, but the ``www-data`` user does
# not have permission to create files in this directory. So permissions to this directory are
# updated as well.
#
# | What                  | Port | Protocol |
# | --------------------- | ---- | -------- |
# | ``local/website:dev`` | 7888 | http     |
#
# The image is intended for local testing purposes. For production use, take a look at the
# link:https://hub.docker.com/r/sommerfeldio/website[``sommerfeldio/website``]  image on
# Dockerhub.


readonly DOCKER_IMAGE="local/website:dev"
readonly PORT=7888


echo -e "$LOG_INFO Remove old versions of $DOCKER_IMAGE"
docker image rm "$DOCKER_IMAGE"

echo -e "$LOG_INFO Build Docker image $DOCKER_IMAGE"
# docker build --progress=plain --no-cache -t "$DOCKER_IMAGE" .
docker build --no-cache -t "$DOCKER_IMAGE" .

echo -e "$LOG_INFO Run Docker image"
docker run --rm mwendler/figlet "$PORT"
docker run --rm -p "$PORT:7888" "$DOCKER_IMAGE"
