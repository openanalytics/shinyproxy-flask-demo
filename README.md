# Running Flask apps inside ShinyProxy

In order to run Flask apps using ShinyProxy you have to consider two things:

- use a WSGI web server to run the Flask app (e.g., gunicorn, uWSGI). This means
  you cannot use the built-in server provided by Flask. Note that the developers
  of Flask advice to not use their built-in server for production usages. The
  [Dockerfile](Dockerfile) in this repository illustrates how you can setup
  gunicorn for a very simple Flask application.
- ensure to use the `url_for` helper when referencing other pages and static
  files. The HTML files in the [app/templates](app/templates) directory show the
  proper usage of the `url_for` helper. For example:
  
    ```html
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
    <a href="{{ url_for('about') }}">About</a>
    <img width="400px" src="{{ url_for('static', filename='logo.png') }}">
    <script src="{{ url_for('static', filename='script.js') }}"></script>
    ```
## Building the Docker image

To pull the image made in this repository from Docker Hub, use

```bash
sudo docker pull openanalytics/shinyproxy-flask-demo
```

The relevant Docker Hub repository can be found at [https://hub.docker.com/r/openanalytics/shinyproxy-flask-demo](https://hub.docker.com/r/openanalytics/shinyproxy-flask-demo])

To build the image from the Dockerfile, navigate into the root directory of this repository and run

```bash
sudo docker build -t openanalytics/shinyproxy-flask-demo .
```

## ShinyProxy Configuration

**Note:** ShinyProxy 2.6.0 or later is required for running Flask apps.

Create a ShinyProxy configuration file (see [application.yml](application.yml)
for a complete file), containing:

```yaml
specs:
  - id: flask-demo
    container-image: openanalytics/shinyproxy-flask-demo
    port: 8080
    container-env:
      SCRIPT_NAME: "#{proxy.getRuntimeValue('SHINYPROXY_PUBLIC_PATH').replaceFirst('/$','')}"
    target-path: "#{proxy.getRuntimeValue('SHINYPROXY_PUBLIC_PATH')}"
```

Note that the `SCRIPT_NAME` environment variable may not end with `/`, therefore
we have to strip it from the variable.

## References

- <https://dlukes.github.io/flask-wsgi-url-prefix.html>
- <https://flask.palletsprojects.com/en/2.0.x/quickstart/#url-building>
- <https://gunicorn.org/>

**(c) Copyright Open Analytics NV, 2021.**
