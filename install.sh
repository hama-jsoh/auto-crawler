. "./utils.sh"

# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb \
 && rm -rf ./google-chrome-stable_current_amd64.deb

CHROME_VERSION=`google-chrome --version | awk '{print $3}'`
CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`

VERSION=${CHROME_VERSION:0:3}
DRIVER_VERSION=${CHROME_DRIVER_VERSION:0:3}

# install chromedriver
install_chromedriver() {

    if [[ $VERSION -eq $DRIVER_VERSION ]]; then
        execute \
            "wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P . \
            && unzip chromedriver_linux64.zip -d ./chromedriver/ \
            && rm chromedriver_linux64.zip \
            && mv chromedriver/chromedriver chromedriver/chromedriver_linux" \
            && print_success "google-chrome version: $CHROME_VERSION" \
            && print_success "chromedriver version: $CHROME_DRIVER_VERSION"
    else
        echo "chromedriver_version does not match the google-chrome_version"
    fi

}


main() {

    install_chromedriver

}

main
