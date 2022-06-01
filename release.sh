IMAGE=skazuki/alpine-node-yarn-install-mecab
TAG=12-dic
docker build . -t ${IMAGE}:${TAG}
# docker push ${IMAGE}:${TAG} # not NOT automated build env