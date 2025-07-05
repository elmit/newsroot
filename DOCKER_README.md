# Newsroot Docker Development Setup

This guide explains how to run the Newsroot Elixir umbrella application using Docker, including PostgreSQL database.

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- Make (optional, for convenience commands)

## 🚀 Quick Start

### 1. Build and Start Everything

```bash
# Option 1: Using Make (recommended)
make quick-start

# Option 2: Using Docker Compose directly
docker-compose build
docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile setup run --rm setup
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

### 2. Access Your Application

- **Phoenix App**: http://localhost:4000
- **PgAdmin** (Database UI): http://localhost:5050
  - Email: `admin@newsroot.dev`
  - Password: `admin`

## 🛠 Available Commands

### Make Commands (Recommended)

```bash
make help              # Show all available commands
make build             # Build Docker images
make dev               # Start services and follow logs
make up                # Start services in background
make down              # Stop all services
make setup             # Run initial database setup
make clean             # Stop services and remove volumes (⚠️ deletes data)
make logs              # Show logs from all services
make logs-app          # Show app logs only
make logs-db           # Show database logs only
make shell             # Open shell in app container
make db-shell          # Open PostgreSQL shell
make test              # Run tests
make restart           # Restart app service
make status            # Show service status
```

### Docker Compose Commands

If you prefer using Docker Compose directly:

```bash
# Start development environment
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Start in background
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Stop services
docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

# View logs
docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

# Execute commands in app container
docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix deps.get
```

## 🗄 Database Management

### Initial Setup

The database is automatically set up when you run `make setup` or the setup service. This includes:

- Creating `newsroot_dev` and `newsroot_test` databases
- Installing PostgreSQL extensions (uuid-ossp, pgcrypto, citext)
- Running migrations and seeds

### Common Database Operations

```bash
# Reset database (drop, create, migrate)
make db-reset

# Run migrations
make migrate

# Rollback last migration
make rollback

# Access PostgreSQL shell
make db-shell

# Or directly with psql
docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec postgres psql -U postgres -d newsroot_dev
```

### Database Connection Info

- **Host**: `postgres` (from within containers) or `localhost` (from host)
- **Port**: `5432`
- **Database**: `newsroot_dev`
- **Username**: `postgres`
- **Password**: `postgres`

## 🔧 Development Workflow

### 1. Start Development Environment

```bash
make dev
```

This will:
- Start PostgreSQL with health checks
- Wait for database to be ready
- Install dependencies
- Run database setup
- Start Phoenix server with live reloading

### 2. Make Code Changes

Your local code is mounted into the container, so changes are reflected immediately thanks to Phoenix's live reloading.

### 3. Run Tests

```bash
make test
```

### 4. Access Services

- Open shell in app container: `make shell`
- View logs: `make logs`
- Check service status: `make status`

## 📁 Project Structure

```
newsroot/
├── Dockerfile                 # Main application Dockerfile
├── docker-compose.yml         # Base Docker Compose configuration
├── docker-compose.dev.yml     # Development overrides
├── .dockerignore              # Files to exclude from Docker context
├── Makefile                   # Convenience commands
├── scripts/
│   └── init-db.sql           # Database initialization script
└── apps/                     # Elixir umbrella apps
    ├── newsroot_core/        # Core business logic with database
    ├── newsroot_web/         # Phoenix web interface
    ├── newsroot_fetcher/     # Data fetching service
    └── newsroot_ai/          # AI integration service
```

## 🐛 Troubleshooting

### Services Won't Start

1. **Check if ports are available**:
   ```bash
   # Check if ports 4000, 5432, or 5050 are in use
   lsof -i :4000,5432,5050
   ```

2. **Rebuild containers**:
   ```bash
   make clean
   make build
   make setup
   make up
   ```

### Database Connection Issues

1. **Wait for PostgreSQL to be ready**:
   ```bash
   make logs-db
   # Look for "database system is ready to accept connections"
   ```

2. **Check database health**:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec postgres pg_isready -U postgres
   ```

### Application Errors

1. **Check application logs**:
   ```bash
   make logs-app
   ```

2. **Restart the application**:
   ```bash
   make restart
   ```

3. **Get fresh dependencies**:
   ```bash
   make shell
   mix deps.clean --all
   mix deps.get
   mix compile
   ```

### Performance Issues

1. **Prune unused Docker resources**:
   ```bash
   docker system prune -f
   ```

2. **Check resource usage**:
   ```bash
   docker stats
   ```

## 🔄 Complete Reset

If you need to start completely fresh:

```bash
make reset
```

This will:
1. Stop all services
2. Remove all volumes (⚠️ **deletes all data**)
3. Rebuild containers
4. Run setup
5. Start services

## 📊 Service Details

### App Service (`newsroot_app`)

- **Base Image**: `elixir:1.17-alpine`
- **Ports**: 4000 (Phoenix), 4001 (LiveView)
- **Environment**: Development mode with live reloading
- **Volumes**: Source code mounted for development

### PostgreSQL Service (`newsroot_postgres`)

- **Image**: `postgres:15-alpine`
- **Port**: 5432
- **Databases**: `newsroot_dev`, `newsroot_test`
- **Extensions**: uuid-ossp, pgcrypto, citext
- **Persistent**: Data stored in Docker volume

### PgAdmin Service (`newsroot_pgadmin`)

- **Image**: `dpage/pgadmin4:latest`
- **Port**: 5050
- **Purpose**: Web-based PostgreSQL administration
- **Login**: admin@newsroot.dev / admin

## 💡 Tips

- Use `make dev` for active development (shows logs)
- Use `make up` to run in background
- The first build may take several minutes
- Dependencies are cached in Docker volumes for faster rebuilds
- Use `make shell` to access the Elixir environment directly
- Database data persists between container restarts
- Use `make clean` only when you want to delete all data

## 🆘 Getting Help

If you encounter issues:

1. Check the logs: `make logs`
2. Verify service status: `make status`
3. Try a complete reset: `make reset`
4. Check Docker resources: `docker system df`

For Elixir-specific issues, use `make shell` to access the container and run standard Mix commands.