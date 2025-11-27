import { Router } from 'express';
import { pool } from '../db.js';

const router = Router();

// GET /api/photos → list photos
router.get('/', async (_req, res) => {
  try {
    const result = await pool.query('SELECT * FROM photo ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err); 
    res.status(500).json({ error: 'Failed to fetch photos' });
  }
});

// POST /api/photos → add photo record (metadata only)
router.post('/', async (req, res) => {
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
});

export default router;

