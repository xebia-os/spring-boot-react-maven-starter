spring-boot-react-multi-module-maven-starter
-----

This is a multi-module Spring Boot React starter app with good defaults. The react app is built using [create-react-app](https://github.com/facebookincubator/create-react-app).

## Features

This starter comes bundled with following features:

1. Multi module Maven project: A multi module project to modularize backend and frontend code separately.
2. Maven wrapper: So, you don't need to install Maven on your machine.
3. Jenkins:
4. Checkstyle: Enforce sane coding standard guidelines.
5. ErrorProne: Find errors in your code.
6. CORS enabled: A global configuration is added to enable CORS so that frontend can work seamlessly with backend during development.
7. REST API base path: Sets the base REST API path to `/api`. You can configure it by changing `rest.api.base.path` property.
8. Release management:
9. Copy paste detection

## Code structure

The application is divided into two Maven modules:

1. `backend`: This contains Java code of the application.
2. `frontend`: This contains all react JavaScript code of the application.

### Hot reloading

With the dev server running, saving your javascript files or stylus assets will automatically trigger the hot reloading
(without browser refresh) of the application.

For the backend, recompiling the project in your IDE will trigger the reloading of the application's class loader.
