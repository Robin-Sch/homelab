FROM debian:bookworm AS build

RUN apt update && \
	apt install -y build-essential automake autoconf cmake git

WORKDIR /home/portspoof

RUN cd /home/portspoof && \
	git clone https://github.com/drk1wi/portspoof && \
	cd portspoof && \
	./configure && \
	make && \
	make install

EXPOSE 4444

CMD portspoof -c /home/portspoof/portspoof/tools/portspoof.conf -s /home/portspoof/portspoof/tools/portspoof_signatures