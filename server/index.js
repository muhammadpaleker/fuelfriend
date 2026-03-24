require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const PLACES_KEY = process.env.PLACES_API_KEY;

if (!PLACES_KEY) {
  console.warn('Warning: PLACES_API_KEY is not set. The proxy will return 500 for requests.');
}

app.get('/nearby', async (req, res) => {
  try {
    const { lat, lng, radius } = req.query;
    if (!lat || !lng) return res.status(400).json({ error: 'lat and lng required' });
    const r = radius || 1000;

    if (!PLACES_KEY) return res.status(500).json({ error: 'Server not configured with PLACES_API_KEY' });

    const url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    const params = {
      location: `${lat},${lng}`,
      radius: r,
      type: 'gas_station',
      key: PLACES_KEY,
    };

    const resp = await axios.get(url, { params });
    return res.status(200).json(resp.data);
  } catch (err) {
    console.error('Proxy error', err?.response?.data || err.message || err);
    return res.status(500).json({ error: 'Places request failed', details: err?.response?.data || err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Places proxy running on port ${PORT}`);
});
