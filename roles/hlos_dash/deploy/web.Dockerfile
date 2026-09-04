FROM node:22-bookworm-slim AS build
ENV PNPM_HOME=/pnpm
ENV PATH=$PNPM_HOME:$PATH
RUN corepack enable && corepack prepare pnpm@9.15.4 --activate
WORKDIR /src/web
COPY web/package.json web/pnpm-lock.yaml ./
COPY ui/ /src/ui/
RUN pnpm install --frozen-lockfile
COPY web/ ./
ARG HLOS_DASH_API_URL=/v1
ENV HLOS_DASH_API_URL=$HLOS_DASH_API_URL
RUN pnpm build
FROM nginx:1.27-alpine
COPY deploy/nginx/hlos-dash.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/web/dist /usr/share/nginx/html
EXPOSE 80
