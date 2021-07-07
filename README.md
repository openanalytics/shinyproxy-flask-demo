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

## ShinyProxy Configuration

**Note:** this configuration makes use of a new configuration option, which is
not yet available in a stable release of ShinyProxy. Therefore you have to use
the snapshot release
`openanalytics/shinyproxy-snapshot:2.5.1-SNAPSHOT-20210521.074523` or [the
respective jar file](https://nexus.openanalytics.eu/repository/snapshots/eu/openanalytics/shinyproxy/2.5.1-SNAPSHOT/shinyproxy-2.5.1-20210521.074523-12.jar).

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
