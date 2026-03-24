# Places Proxy

A tiny Express proxy that calls Google Places Nearby Search so your app doesn't embed the Places API key in client builds.

Quick start:

1. Copy `.env.example` to `.env` and add your `PLACES_API_KEY`.

2. Install deps and start:

```bash
cd server
npm install
npm start
```

3. The proxy exposes `/nearby?lat=<lat>&lng=<lng>&radius=<meters>` and returns the raw Places Nearby Search JSON.

4. In the Flutter app, the default proxy base URL is `http://localhost:3000`. You can change it via Dart compile-time environment variable `PLACES_PROXY_URL` or by editing `lib/services/places_service.dart`.

Security:
- Keep the `.env` file out of version control.
- Restrict your API key in Google Cloud to the server's IP where possible.
