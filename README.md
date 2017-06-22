# spring-boot-react-app

This is a multi-module Spring Boot React app with good defaults. The react app is built using [create-react-app](https://github.com/facebookincubator/create-react-app).

## Features

This starter comes bundled with following features:

1. TravisCI
2. Checkstyle
3. ErrorProne
4. CORS enabled
5. REST API base path

## Code structure

The application is divided into two Maven modules:

1. `backend`: This contains Java code of the application.
2. `frontend`: This contains all react JavaScript code of the application.

### Hot reloading

With the dev server running, saving your javascript files or stylus assets will automatically trigger the hot reloading
(without browser refresh) of the application.

For the backend, recompiling the project in your IDE will trigger the reloading of the application's class loader.
