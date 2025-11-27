import { pool } from '../src/db.js';

export default async function handler(req, res) {
  if (req.method === 'GET') {
    try {
      const result = await pool.query('SELECT * FROM photo ORDER BY created_at DESC');
      res.status(200).json(result.rows);
    } catch (err) {
      res.status(500).json({ error: 'Failed to fetch photos' });
    }
  } else if (req.method === 'POST') {
    const { event_id, url, caption } = req.body;
    if (!event_id || !url) return res.status(400).json({ error: 'Missing required fields' });

    try {
      const result = await pool.query(
        'INSERT INTO photo (event_id, url, caption) VALUES ($1, $2, $3) RETURNING *',
        [event_id, url, caption || null]
      );
      res.status(201).json(result.rows[0]);
    } catch (err) {
      res.status(500).json({ error: 'Failed to add photo' });
    }
  } else {
    res.status(405).json({ error: 'Method not allowed' });
  }
}