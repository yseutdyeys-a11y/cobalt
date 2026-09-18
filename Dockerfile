FROM ghcr.io/imputnet/cobalt:10

EXPOSE 9000

CMD ["node", "src/index.js"]
