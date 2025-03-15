FROM devopsfaith/krakend:2.7.1

RUN apk add --no-cache curl

COPY --chmod=755 start.sh ./

CMD ["./start.sh"]
