FROM devopsfaith/krakend:2.9.3

RUN apk add --no-cache tzdata curl

COPY --chmod=755 start.sh ./

CMD ["./start.sh"]
