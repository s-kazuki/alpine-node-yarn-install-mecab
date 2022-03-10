IMAGE=skazuki/alpine-node-yarn-install-mecab
TAG=16
docker build . -t ${IMAGE}:${TAG}
# docker push ${IMAGE}:${TAG} # not NOT automated build env