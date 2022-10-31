# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

CHROME_VERSION=`google-chrome --version | awk '{print $3}'`
CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`

VERSION=${CHROME_VERSION:0:3}
DRIVER_VERSION=${CHROME_DRIVER_VERSION:0:3}

# install chromedriver
if [[ $VERSION -eq $DRIVER_VERSION ]]
then
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P .
    unzip chromedriver_linux64.zip -d ./chromedriver/
else
    echo "chromedriver_version does not match the google-chrome_version"
fi