# Use Debian-based Elixir image instead of Alpine
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
COPY apps/newsroot_ai/mix.exs ./apps/newsroot_ai/
COPY apps/newsroot_core/mix.exs ./apps/newsroot_core/
COPY apps/newsroot_fetcher/mix.exs ./apps/newsroot_fetcher/
COPY apps/newsroot_web/mix.exs ./apps/newsroot_web/
COPY config/ ./config/

# Install dependencies
RUN mix deps.get

# Copy the rest of the application
COPY . .

# Install npm dependencies for web assets if they exist
# RUN if [ -f "apps/newsroot_web/assets/package.json" ]; then \
#    cd apps/newsroot_web/assets && npm install; \
#    fi

# Compile the application
RUN mix deps.compile

# Expose port for Phoenix
EXPOSE 4000

# Default command
CMD ["mix test"]
