FROM skazuki/alpine-node

LABEL maintainer="S-Kazuki<contact@revoneo.com>"

ENV APP_ROOT=/node \
MECAB_VERSION=0.996 \
IPADIC_VERSION=2.7.0-20070801 \
MECAB_URL=https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE \
IPADIC_URL=https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM \
MECAB_BUILD_DEPS="curl git bash file sudo openssh autoconf" \
MECAB_RUN_DEPS=openssl

WORKDIR $APP_ROOT

# Installing mecab
RUN apk add --update --no-cache build-base \
&& apk add --update --no-cache --virtual .mecab-build-deps ${MECAB_BUILD_DEPS} \
&& apk add --update --no-cache --virtual .mecab-run-deps ${MECAB_RUN_DEPS} \
&& curl -SL -o ${APP_ROOT}/mecab-${MECAB_VERSION}.tar.gz ${MECAB_URL} \
&& cd ${APP_ROOT} && tar -zxf mecab-${MECAB_VERSION}.tar.gz \
&& cd ${APP_ROOT}/mecab-${MECAB_VERSION} \
&& ./configure --enable-utf8-only --with-charset=utf8 \
&& make \
&& make install \
\
# Installing dictionary
&& curl -SL -o ${APP_ROOT}/mecab-ipadic-${IPADIC_VERSION}.tar.gz ${IPADIC_URL} \
&& cd ${APP_ROOT} && tar -zxf mecab-ipadic-${IPADIC_VERSION}.tar.gz \
&& cd ${APP_ROOT}/mecab-ipadic-${IPADIC_VERSION} \
&& ./configure --with-charset=utf8 \
&& make \
&& make install \
\
# Installing neologd
&& cd ${APP_ROOT} \
&& git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
&& ${APP_ROOT}/mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -a -y \
&& mecab -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd \
\
# Cleaning up
&& rm -rf ${APP_ROOT}/mecab-*

ONBUILD COPY package.json ${APP_ROOT}/
ONBUILD COPY yarn.lock ${APP_ROOT}/

ONBUILD RUN yarn install --frozen-lockfile --ignore-optional

CMD ["yarn", "start"]