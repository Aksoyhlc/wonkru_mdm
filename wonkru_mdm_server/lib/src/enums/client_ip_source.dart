/// Source of the client IP (`CLIENT_IP_SOURCE`).
enum ClientIpSource {
  /// Raw socket address (default); correct when the server is reached directly.
  socket,

  /// Reverse proxy headers: `X-Forwarded-For` (first hop) / `Forwarded`.
  proxy,

  /// Cloudflare Tunnel/Proxy: `CF-Connecting-IP` first, then proxy headers.
  cloudflare,
}
