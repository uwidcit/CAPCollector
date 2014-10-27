#!/bin/bash
#
# Script to set up CAP Tools for running locally.
# It installs required Python modules and does post-configuration steps.
# The script was tested on Debian Linux OS with Python 2.7.
# Please run the following command first to install the required packages:
# sudo apt-get install $(grep -vE "^\s*#" packages.txt | tr "\n" " ")
# This script should be from a new directory you create to contain the running
# server. No superuser privileges required.

# TODO(arcadiy): automate code checkout and virtual environment setup processes
# after we check in code to GitHub.

PIP="../venv/bin/pip"
PYTHON="../venv/bin/python"

# Check virtual environment setup.
if [ ! -e "$PIP" ] && [ ! -e "$PYTHON" ]; then
  echo "Script expects that you have first run 'virtualenv ../venv'"
  exit 1
fi

# Install required modules if they don't already exist:
$PIP install -r requirements.txt

# Generate Django secret key.
SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-z0-9!@#$%^&*()_+' | fold -w 50 | head -n 1)
echo "SECRET_KEY='$SECRET_KEY'" > ./sensitive.py

# Link client part of the application.
if [ ! -e ./static ]; then
  ln -s ../CAPCreator ./static
fi

# Download JQuery JS library, used to render the user interface.
wget http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js -O ./static/js/jquery-1.10.2.min.js

# Download JQuery library map file, not required for production, but improves debugger experience.
wget http://code.jquery.com/jquery-1.10.2.min.map -O ./static/js/jquery-1.10.2.min.map

# Download JQuery Mobile JS library, which improves things like touch support.
wget http://code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.js -O ./static/js/jquery.mobile-1.3.0.min.js
wget http://code.jquery.com/mobile/1.3.0/images/icons-36-white.png -O ./static/css/images/icons-36-white.png

# Download OpenLayers JS library, for displaying a dynamic map to create areas.
wget https://cdnjs.cloudflare.com/ajax/libs/openlayers/2.13.1/OpenLayers.js -O ./static/js/OpenLayers.js
wget https://github.com/openlayers/openlayers/blob/master/img/east-mini.png -O ./static/img/east-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/north-mini.png -O ./static/img/north-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/south-mini.png -O ./static/img/south-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/west-mini.png -O ./static/img/west-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/zoom-minus-mini.png -O ./static/img/zoom-minus-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/zoom-plus-mini.png -O ./static/img/zoom-plus-mini.png
wget https://github.com/openlayers/openlayers/blob/master/img/zoom-world-mini.png -O ./static/img/zoom-world-mini.png

# Download JQuery mobile CSS file.
wget http://code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.css -O ./static/css/jquery.mobile-1.3.0.min.css

# Get database related input.
echo "For development, the CAP Collector tool stores alerts in a built-in local database."
echo "To use the CAP Collector in a production environment, you must connect it to a persistent database and configure that here."
echo "For Google Cloud Storage, refer to https://cloud.google.com/appengine/docs/python/cloud-sql/django#usage for the correct parameters."
echo "For MySQL, refer to https://docs.djangoproject.com/en/dev/ref/databases/#connecting-to-the-database."
echo "For Oracle or others, you will also have to edit settings_prod.py."
echo -n "Enter database host or IP address (leave blank to use a local database): "
read DB_HOST

if [ "$DB_HOST" ]; then
  echo -n "Enter database name: "
  read DB_NAME

  echo -n "Enter database username: "
  read DB_USER

  echo -n "Enter database password: "
  read -s DB_PASSWORD
fi

echo "DATABASE_HOST='$DB_HOST'" >> ./sensitive.py
echo "DATABASE_NAME='$DB_NAME'" >> ./sensitive.py
echo "DATABASE_USER='$DB_USER'" >> ./sensitive.py
echo "DATABASE_PASSWORD='$DB_PASSWORD'" >> ./sensitive.py

# Sync Django models to databse. This involves superuser creation.
$PYTHON manage.py syncdb

# Compile translation messages to .mo files.
$PYTHON manage.py compilemessages

# Collect static files.
$PYTHON manage.py collectstatic -v0 --noinput
