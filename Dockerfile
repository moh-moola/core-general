# NOTE: To pull in a local image, it needs to be built out to your local repo
# first and then make use of FROM as usual.

# Base GE image, based of off LTS Ubuntu 16.04. With Python 3.5.
FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
    python3 \
    python-virtualenv
# NOTE: Project making use of this one will need to install its own deps.
# Overlapping ones  can be added here Girl Effect matures.
# eg: nginx, supervisor, etc.

# NOTE: Depending on  project type more directories will be needed.
RUN virtualenv /var/app/ve -p python3

# NOTE Projects need to have and copy their respective nginx/supervisor configs.
# eg:
# COPY config/supervisor/* /etc/supervisor/conf.d/
# COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Set app directory to working directory.
ONBUILD WORKDIR /var/app
# Activate virtual env.
ONBUILD RUN ./ve/bin/activate
