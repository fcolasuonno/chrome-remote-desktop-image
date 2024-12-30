FROM linuxserver/firefox:latest

ENV DEBIAN_FRONTEND=noninteractive

# INSTALL SOURCES FOR CHROME REMOTE DESKTOP
RUN apt-get update && apt-get upgrade --assume-yes
RUN apt-get --assume-yes install wget megatools openjdk-17-jre libmediainfo0v5 fonts-dejavu bash lxterminal transmission xrdp thunar adwaita-icon-theme wireguard-tools python3 python3-requests pkexec policykit-1 psmisc python3-packaging python3-psutil python3-xdg xbase-clients xinit xserver-xorg-video-dummy xvfb
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
RUN dpkg --install chrome-remote-desktop_current_amd64.deb
RUN apt-get install --assume-yes --fix-broken
RUN bash -c 'echo "exec /etc/X11/Xsession /usr/bin/openbox-session" > /etc/chrome-remote-desktop-session'

# ---------------------------------------------------------- 
# use 6 digits at least
ENV PIN=123456
ENV CODE=4/xxx
ENV HOSTNAME=RemoteDesktop
# ---------------------------------------------------------- 

COPY root/ /

# ADD USER TO THE SPECIFIED GROUPS

RUN usermod -aG chrome-remote-desktop abc
WORKDIR /config
RUN mkdir -p .config/chrome-remote-desktop
RUN chown "abc:abc" .config/chrome-remote-desktop
RUN chmod a+rx .config/chrome-remote-desktop
RUN touch .config/chrome-remote-desktop/host.json
RUN echo "/usr/bin/openbox-session" > .chrome-remote-desktop-session
CMD sleep infinity & wait
