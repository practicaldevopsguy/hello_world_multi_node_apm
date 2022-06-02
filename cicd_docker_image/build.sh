#!/usr/bin/bash

# --------------------------------
PROJECT=hello_world_multi_node_apm
# --------------------------------

# check if the build process is locked, if not, lock it
[ -f "/work/build.lock" ] && echo "Build is running, exiting... " && exit 0
touch /work/build.lock

echo $(date +"%Y-%m-%d %T") - Build script started

# refresh source from git
[ ! -d "/work/$PROJECT" ] && cd /work && git clone ssh://cicd@192.168.1.104:/DATA/git/$PROJECT && touch /work/do_build
[ -d "/work/$PROJECT" ] && cd /work/$PROJECT && git pull | grep -v "Already up to date" && touch /work/do_build

# build if code is just cloned or updated
if [ -f "/work/do_build" ]
then

	echo $(date +"%Y-%m-%d %T") -- Start building
	cd /work/$PROJECT
	echo $(date +"%Y-%m-%d %T") --- building docker image
	docker login -u="cicd" -p="cicd" 192.168.1.104:5000
	docker build -t practicaldevopsguy/$PROJECT .
	docker tag practicaldevopsguy/$PROJECT:latest 192.168.1.104:5000/practicaldevopsguy/$PROJECT:latest
	docker push 192.168.1.104:5000/practicaldevopsguy/$PROJECT:latest
	echo $(date +"%Y-%m-%d %T") --- check kubernetes nodes
  kubectl get nodes
  echo $(date +"%Y-%m-%d %T") --- deploy kubernetes pod
  kubectl replace -f deployment.yaml --force

rm /work/do_build
fi

echo $(date +"%Y-%m-%d %T") - DONE
echo

# remove lock, refresh build script
rm /work/build.lock
cp /work/$PROJECT/cicd_docker_image/build.sh /work/build.sh
