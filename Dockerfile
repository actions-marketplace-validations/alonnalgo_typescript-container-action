FROM node:12-alpine AS builder
WORKDIR /action
COPY package*.json ./
RUN npm ci
COPY tsconfig*.json ./
COPY src/ src/
RUN npm run build \
  && npm prune --production
FROM node:12-alpine
RUN apk update
RUN apk add --no-cache tini
RUN apk add install git
COPY --from=builder action/package.json .
COPY --from=builder action/lib lib/
COPY --from=builder action/node_modules node_modules/
RUN /changedFiles.sh
ENTRYPOINT [ "/sbin/tini", "--", "node", "/lib/index.js" ]
