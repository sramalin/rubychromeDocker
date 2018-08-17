FROM ruby



#=========
# Env variables
#=========

ENV GROOVY_VERSION 2.4.5
ENV CHROME_DRIVER_VERSION 2.41

# Upgrading the apt-get packages
RUN apt-get update
RUN apt-get upgrade -y

# Installing unzip
RUN apt-get install -y wget unzip

#=========
# Adding Headless Selenium with Chrome and Firefox
#=========

# Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y \
    google-chrome-stable

# Dependencies to make "headless" selenium work
RUN apt-get -y install \
    gtk2-engines-pixbuf \
    libxtst6 \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-cyrillic \
    xfonts-scalable \
    xvfb

# Starting xfvb as a service
ENV DISPLAY=:99
RUN Xvfb $DISPLAY -screen 0 1024x768x16 &


# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 2.41
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH

RUN mkdir /app

USER root

