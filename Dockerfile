FROM node:slim as builder

RUN apt update \
  && apt install -y libX11-6 libgl1-mesa-glx libfontconfig libxrender1 libxcomposite1-dbg python wget tar xz-utils pkg-config xvfb \
  && wget --quiet -k https://download.calibre-ebook.com/linux-installer.sh \
  && chmod +x linux-installer.sh \
  && ./linux-installer.sh

RUN mkdir /srv/gitbook

WORKDIR /srv/gitbook

COPY package.json .
COPY book.json .

RUN npm install \
  && npm run prepare

COPY README.md .
COPY SUMMARY.md .
COPY example ./example:wget

RUN npm run build:static \
  && npm run build:pdf


FROM nginx:alpine

WORKDIR /usr/share/nginx/html/

COPY --from=builder /srv/gitbook/book.pdf ./downloads/book.pdf
COPY --from=builder /srv/gitbook/_book/ .

# Directory to copy the static content is run on /usr/share/nginx/html

