FROM ubuntu:19.10 as base

FROM base as build
RUN apt-get update && apt-get install -y build-essential libwiringpi-dev libsqlite3-dev

COPY . /code
WORKDIR /code
RUN make

FROM base
RUN	apt-get update && \
	apt-get install -y libwiringpi2 libsqlite3-0 curl && \
	mkdir /conf && \
	ln -s /conf/settings /settings && \
	ln -s /conf/db.sql /db.sql && \
	rm -rf /var/lib/apt/lists/*

COPY --from=build /code/web /web
COPY --from=build /code/sprinklers_pi /

CMD [ "./sprinklers_pi" ]

EXPOSE 8080
