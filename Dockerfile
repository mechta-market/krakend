FROM devopsfaith/krakend:2

RUN apk add --no-cache curl

CMD ["./start.sh"]
