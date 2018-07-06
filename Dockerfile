FROM jekyll/builder as builder

COPY _config.yml /srv/jekyll/
COPY _posts/ /srv/jekyll/_posts/
COPY about.md /srv/jekyll/
COPY index.md /srv/jekyll/
COPY 404.html /srv/jekyll/
COPY Gemfile /srv/jekyll/
COPY Gemfile.lock /srv/jekyll/

WORKDIR /srv/jekyll

RUN jekyll build --force 

FROM nginx:alpine

WORKDIR /usr/share/nginx/html/

COPY --from=builder /srv/jekyll/_site/ .
