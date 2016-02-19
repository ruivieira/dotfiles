#!env sh

if [ "$EUID" -ne 0 ]
  then echo "Please run this as root."
  exit
fi

# copy the files in bin
cp bin/* /usr/local/bin
