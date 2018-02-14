FROM arm32v7/node:latest

ARG CNCJS_VER

RUN npm install -g cncjs@$CNCJS_VER --unsafe-perm

EXPOSE 8000
CMD ["/usr/local/bin/cnc"]

