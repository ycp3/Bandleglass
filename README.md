
# Bandleglass

## Running locally

This app is designed for use with VSCode Dev Containers.

First, create the env file at `/docker/.env`, and paste the following, making sure to provide a valid [Riot API Key](https://developer.riotgames.com/).
```
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=password
REDIS_URL=redis://bandleglass_redis:6379
RIOT_API_KEY=YOUR_API_KEY_HERE
```

Ensure the "Dev Containers" extension is installed, then navigate to the project's root directory. Use Cmd/Ctrl + Shift + P to open up the Command Palette and select "Dev Containers: Reopen in Container".

In the container, use `rails s -b 0.0.0.0` to start up the server, which can be accessed from your browser at `https://localhost:3000/`.
