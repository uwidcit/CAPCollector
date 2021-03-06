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

PIP="./venv/bin/pip"
PIP_LIBS="./venv/local/lib/python2.7/site-packages"
PYTHON="./venv/bin/python"

# Check virtual environment setup.
#if [ ! -e "$PIP" ] && [ ! -e "$PYTHON" ]; then
#  echo "Script expects that you have first run 'virtualenv ./venv'"
#  exit 1
#fi

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
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/east-mini.png -O ./static/img/east-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/north-mini.png -O ./static/img/north-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/south-mini.png -O ./static/img/south-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/west-mini.png -O ./static/img/west-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/zoom-minus-mini.png -O ./static/img/zoom-minus-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/zoom-plus-mini.png -O ./static/img/zoom-plus-mini.png
wget https://raw.githubusercontent.com/benoitc/afgwardiary/master/_attachments/openlayers/img/zoom-world-mini.png -O ./static/img/zoom-world-mini.png

# Download JQuery mobile CSS file.
wget http://code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.css -O ./static/css/jquery.mobile-1.3.0.min.css

# Download jQuery UI library, required for displaying datetime picker for alert expiration "Other" option.
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js -O ./static/js/jquery-ui-1.10.4.min.js
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.min.css -O ./static/css/jquery-ui-1.10.4.min.css
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_glass_75_dadada_1x400.png -O ./static/css/images/ui-bg_glass_75_dadada_1x400.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_glass_55_fbf9ee_1x400.png -O ./static/css/images/ui-bg_glass_55_fbf9ee_1x400.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_highlight-soft_75_cccccc_1x100.png -O ./static/css/images/ui-bg_highlight-soft_75_cccccc_1x100.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_glass_75_e6e6e6_1x400.png -O ./static/css/images/ui-bg_glass_75_e6e6e6_1x400.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_glass_65_ffffff_1x400.png -O ./static/css/images/ui-bg_glass_65_ffffff_1x400.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-icons_222222_256x240.png -O ./static/css/images/ui-icons_222222_256x240.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-bg_flat_75_ffffff_40x100.png  -O ./static/css/images/ui-bg_flat_75_ffffff_40x100.png
wget http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/images/ui-icons_454545_256x240.png  -O ./static/css/images/ui-icons_454545_256x240.png

# Download Timepicker addon to jQuery UI Datepicker, for displaying datetime picker for alert expiration "Other" option.
wget http://trentrichardson.com/examples/timepicker/jquery-ui-timepicker-addon.js -O ./static/js/jquery-ui-timepicker-addon.js
wget http://trentrichardson.com/examples/timepicker/jquery-ui-timepicker-addon.css -O ./static/css/jquery-ui-timepicker-addon.css

# Download Select2 library for customizable select box.
wget http://cdnjs.cloudflare.com/ajax/libs/select2/4.0.0/js/select2.min.js -O ./static/js/select2.min.js
wget http://cdnjs.cloudflare.com/ajax/libs/select2/4.0.0/css/select2.min.css -O ./static/css/select2.min.css

# Download Moment JS libraries with time zone suport for datetime conversion in any timezone.
wget http://momentjs.com/downloads/moment.min.js -O ./static/js/moment.min.js
wget http://momentjs.com/downloads/moment-timezone-with-data.min.js -O ./static/js/moment-timezone-with-data.min.js

echo -n "Are you going to host this application on Google Appengine? [y/n]: "
read APPENGINE

if  [ "$APPENGINE" == "y" ]; then
  if [ ! -e ./libs ]; then
    mkdir libs
  fi

  #LIBS=(bs4 dateutil django pytz session_csrf six.py)

  #echo -n "Copying files, this might take a while..."
  #for lib in ${LIBS[@]}; do
  #  cp -r $PIP_LIBS/$lib libs/
  #done
fi

# Get database related input.
echo "For development, the CAP Collector tool stores alerts in a built-in local database."
echo "To use the CAP Collector in a production environment, you must connect it to a persistent database and configure that here."
echo "For Google Cloud Storage, refer to https://cloud.google.com/appengine/docs/python/cloud-sql/django#usage for the correct parameters."
echo "For MySQL, refer to https://docs.djangoproject.com/en/dev/ref/databases/#connecting-to-the-database."
echo "For Oracle or others, you will also have to edit settings_prod.py."
echo -n "Enter database host or IP address (leave blank to use a local development only database): "
read DATABASE_HOST

if [ "$DATABASE_HOST" ]; then
  echo -n "Enter database name: "
  read DATABASE_NAME

  echo -n "Enter database username: "
  read DATABASE_USER

  echo -n "Enter database password: "
  read DATABASE_PASSWORD
fi

echo "DATABASE_HOST='$DATABASE_HOST'" >> ./sensitive.py
echo "DATABASE_NAME='$DATABASE_NAME'" >> ./sensitive.py
echo "DATABASE_USER='$DATABASE_USER'" >> ./sensitive.py
echo "DATABASE_PASSWORD='$DATABASE_PASSWORD'" >> ./sensitive.py

# Advanced configuration for development database.
echo "" >> ./sensitive.py
echo "# Flags for testing against a development MySQL database. This is used by default with AppEngine's dev_appserver," >> ./sensitive.py
echo "# and can also be turned on by running 'export CAP_TOOLS_DB=dev', but this is not required if using Django's internal sqlite db." >> ./sensitive.py
echo "DEV_DATABASE_HOST=''" >> ./sensitive.py
echo "DEV_DATABASE_NAME=''" >> ./sensitive.py
echo "DEV_DATABASE_USER=''" >> ./sensitive.py
echo "DEV_DATABASE_PASSWORD=''" >> ./sensitive.py

# Advanced configuration for accessing the CloudSQL production database from a development environment.
echo "" >> ./sensitive.py
echo "# Set this variables to access production CloudSQL instance from development environment." >> ./sensitive.py
echo "PROD_FROM_DEV_DATABASE_HOST=''" >> ./sensitive.py
echo "PROD_FROM_DEV_DATABASE_NAME=''" >> ./sensitive.py
echo "PROD_FROM_DEV_DATABASE_USER=''" >> ./sensitive.py
echo "PROD_FROM_DEV_DATABASE_PASSWORD=''" >> ./sensitive.py

# Sync Django models to databse. This involves superuser creation.
$PYTHON manage.py makemigrations

$PYTHON manage.py migrate

#$PYTHON manage.py createsuperuser

# Compile translation messages to .mo files.
$PYTHON manage.py compilemessages

# Collect static files.
$PYTHON manage.py collectstatic -v0 --noinput
