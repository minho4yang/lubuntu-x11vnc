FROM lubuntu-sshd

EXPOSE 5900

ENV DEBIAN_FRONTEND noninteractive
ENV USER chrome
ENV HOME /home/chrome

ADD google_linux_signing_key.pub /tmp/google_linux_signing_key.pub
RUN apt-key add /tmp/google_linux_signing_key.pub && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && useradd -ms /bin/bash chrome

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        hicolor-icon-theme \
        google-chrome-stable \
        x11vnc xvfb

ADD desktop-init /usr/bin/
RUN chmod a+rx /usr/bin/desktop-init

ADD supervisord.conf /
USER root
WORKDIR /home/chrome
RUN chown chrome:chrome /home/chrome/.cache

CMD ["/usr/bin/supervisord",  "-c", "/supervisord.conf"]
