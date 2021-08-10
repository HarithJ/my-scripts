# Build stage:
FROM python:3.9-alpine3.12 as build

WORKDIR /usr/src/app

RUN apk add --virtual build-deps \
    gcc \
    libpq \
    python3-dev \
    musl-dev \
    g++

RUN apk add postgresql-dev

# install python dependencies
COPY requirements.txt ./
RUN pip3 wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt


# Development stage:
FROM build as dev

# Install packages
COPY --from=build /usr/src/app/wheels /wheels
COPY --from=build /usr/src/app/requirements.txt .
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache /wheels/*

EXPOSE 5000


# Production stage:
FROM python:3.9-alpine3.12 as prod

WORKDIR /usr/src/app

RUN apk add --no-cache libpq

# Copy generated site-packages from former stage:
COPY --from=build /usr/src/app/wheels /wheels
COPY --from=build /usr/src/app/requirements.txt .
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache /wheels/*

COPY app ./app
COPY configmodule ./configmodule
COPY database ./database
COPY migrations ./migrations
COPY swagger.yml .
COPY titanic.csv .

# install waitress to serve the app in prod
RUN pip3 install waitress

# Create user and set ownership and permissions as required
RUN adduser -D titanic && chown -R titanic /usr/src/app
USER titanic
