FROM ghcr.io/imputnet/cobalt:10

ENV PORT=9000
ENV API_URL=https://cobalt-bx4u.onrender.com/
ENV ENVIRONMENT=production

ENTRYPOINT ["node", "/app/src/index.js"]
