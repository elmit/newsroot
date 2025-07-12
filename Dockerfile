# Use Debian-based Elixir image
FROM elixir:1.17

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    nodejs \
    npm \
    postgresql-client \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set working directory
WORKDIR /app

# Set environment variables for development
ENV MIX_ENV=dev
ENV ERL_AFLAGS="-kernel shell_history enabled"

# Copy mix files first for better caching
COPY mix.exs mix.lock ./
COPY config/ ./config/

# Install dependencies
RUN mix deps.get

# Copy the rest of the application
COPY . .

# Compile the application
RUN mix deps.compile

EXPOSE 4000

CMD ["mix", "test"]
