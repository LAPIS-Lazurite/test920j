#! /bin/bash

echo 'STEP1:: update install gem,ruby-dev and xmodem'
sudo apt-get install ruby-dev gem lrzsz


echo 'STEP2:: install serialport'
sudo gem install serialport


echo 'STEP3:: install ftdi library'
sudo cp lib/cpp/ftdi/build/libftd2xx.* /usr/local/lib
sudo chmod 0755 /usr/local/lib/libftd2xx.so.1.3.6
sudo chmod 0755 /usr/local/lib/libftd2xx.so.1.3.6
sudo ln -sf /usr/local/lib/libftd2xx.so.1.3.6 /usr/local/lib/libftd2xx.so

