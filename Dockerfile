# FROM node:12-alpine AS builder
# WORKDIR /action
# COPY package*.json ./
# RUN npm ci
# COPY tsconfig*.json ./
# COPY src/ src/
# RUN npm run build \
#   && npm prune --production
FROM node:12-alpine
RUN apk update
RUN apk add tini git bash
RUN mkdir -p /scripts
COPY scripts/changedFiles.sh  /scripts
WORKDIR /scripts
RUN chmod +x changedFiles.sh
RUN ./changedFiles.sh
# COPY --from=builder action/package.json .
# COPY --from=builder action/lib lib/
# COPY --from=builder action/node_modules node_modules/
ENTRYPOINT [ "/sbin/tini", "--", "node", "/lib/index.js" ]
