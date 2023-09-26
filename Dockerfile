FROM debian:latest

RUN apt update && apt install build-essential ssh vim sudo zsh curl git socat -y
RUN echo 'root:test123' | chpasswd
RUN echo 'pts/1' >> /etc/securetty
RUN useradd -m -s /usr/bin/zsh -G sudo user
RUN echo 'user:test123' | chpasswd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -i 's/#MaxAuthTries 6/MaxAuthTries 50/g' /etc/ssh/sshd_config
RUN USER=user ln -s /projects /home/user/projects
RUN USER=user mkdir -p /home/user/.ssh && touch /home/user/.ssh/authorized_keys
RUN USER=user echo 'export SSH_AUTH_SOCK="/home/user/.SSH_AGENT"' > /home/user/.zprofile
RUN service ssh start

RUN echo '#!/bin/bash' > /init.sh
RUN echo 'echo "$PUBLIC_KEY" > /home/user/.ssh/authorized_keys' >> /init.sh
RUN echo 'rm -f /home/user/.SSH_AGENT' >> /init.sh
RUN echo 'sudo -u user socat UNIX-LISTEN:/home/user/.SSH_AGENT,fork TCP4:127.0.0.1:15432 &' >> /init.sh
RUN echo '/usr/sbin/sshd -D' >> /init.sh
RUN chmod +x /init.sh

ENV PUBLIC_KEY $PUBLIC_KEY

EXPOSE 22

CMD ["sh", "-c", "/init.sh"]