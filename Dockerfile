FROM alpine:3.10

COPY dotenv.sh /dotenv.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
