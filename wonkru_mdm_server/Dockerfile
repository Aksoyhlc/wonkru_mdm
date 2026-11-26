# Build from the project root with:
# docker build -f wonkru_mdm_server/Dockerfile .

# Build stage
FROM dart:3.12.2 AS build

# Create a minimal workspace that preserves locked server dependency versions.
WORKDIR /app
COPY pubspec.lock .
COPY wonkru_core_server wonkru_core_server
COPY wonkru_mdm_server wonkru_mdm_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - wonkru_core_server' \
  '  - wonkru_mdm_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/wonkru_mdm_server
RUN [ -s assets/agent/wonkru-mdm.apk ] && [ -s assets/agent/wonkru-mdm-apk.json ]
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Add a fallback for the copy of possibly missing directories.
RUN mkdir -p config web migrations certs

# Final stage
FROM alpine:3.24
RUN apk upgrade --no-cache
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Uploaded files: private files require signed URLs; public files allow direct access.
# Mount persistent storage here to retain files when replacing the container.
ENV STORAGE_PATH=/app/storage

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/wonkru_mdm_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/wonkru_mdm_server/config/ config/
COPY --from=build /app/wonkru_mdm_server/web/ web/
COPY --from=build /app/wonkru_mdm_server/migrations/ migrations/

# Unicode fonts embedded in PDF reports.
COPY --from=build /app/wonkru_mdm_server/assets/ assets/

# Optional local CA certificate (LOCAL_CA_PATH default: certs/local-ca.crt).
COPY --from=build /app/wonkru_mdm_server/certs/ certs/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/wonkru_mdm_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Persistent upload storage.
RUN mkdir -p "$STORAGE_PATH/private" "$STORAGE_PATH/public"
VOLUME ["/app/storage"]

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Apply pending migrations at startup.
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
