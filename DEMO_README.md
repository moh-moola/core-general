# Wagtail demo setup.

* _Setup docker network for static ips._
`$ make docker-network`

* _Run the docker compose spin up command._
`$ make run`

* _Get a list of the running docker containers._
`$ docker ps -a`

* _Look for a container similar to this:_
```<id>        ge-auth:0.1         "scripts/waitFor.sh …"   27 minutes ago      Up 27 minutes       0.0.0.0:8000->8000/tcp             coregeneral_core-authentication-service_1```

* _Attach to the currently running container_
`$ docker exec -ti <id> /bin/bash`

* _Load the demo clients_
`$ python manage.py demo_content`

* _Create rsa keys for the clients._
`$ python manage.py creatersakey`

* _Next attach to the core_access_control container and run the following:_
`$ python seed_data.py`

`TEMP NOTE: In the event that the core_authentication container exits with a code 1 and complains about a TCP/IP issue. Simply restart that singular container. Its a know issue, the django app attempts to access the DB before it is ready.`

In order to be able to access the services by name from a browser on the host system, the browser needs to be configured to use the proxy running inside the compose environment. In your favourite browser, point your proxy to: `http://localhost:3128` for hostnames starting with `core-*` and `wagtail-*`. If you are on a Mac, you can use the `proxy.pac` located at `http://localhost:3129/app/proxy.pac` to configure your proxy.

Once everything is done, the wagtail demo applications should be accessible on
* `http://wagtail-demo-1-site-1:8000/`
* `http://wagtail-demo-1-site-2:8000/`
* `http://wagtail-demo-2-site-1:8000/`

It will redirect to the authentication service running on `http://core-authentication-service:8000/`

### User Credentials for Wagtail Demo:

* The superuser credentials for the Authentication Service is username `admin` and password `local`.

* The enduser credentials for the Authentication Service is username `enduser` and password `enduser`.

* The systemuser credentials for the Authentication Service is username `sysuser` and password `sysuser`. It
also includes 2FA, that requires Google Authenticator to be set up. The QR code to use with Google
Authenticator:

![alt text][logo]

[logo]:  https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=otpauth%3A%2F%2Ftotp%2FGirl%2520Effect%2520Demo%253A%2520sysuser%3Fsecret%3DVFFGMP7P36Q7TIZV3YZ65ZLHKQPAPXIM%26digits%3D6%26issuer%3DGirl%2BEffect%2BDemo "Girl Effect Demo QR code"

### Generating Access Control Seed Data:

After starting up the demo, you can add Domains, Roles, Permissions, and Resources. To do this, follow these steps:

* List the running containers using: `$ docker ps -a`.

* Find the container similar to: `<id>        coregeneral_core-access-control     "python3 -m swagger_…"   16 minutes ago      Up 16 minutes                  8080/tcp                  coregeneral_core-access-control_1`.

* Attach to the currently running container using: `$docker exec -ti <id> /bin/bash`.

* Load the seed data with the following command: `$ python seed_data.py`.

* You can exit the container with: `exit`.
