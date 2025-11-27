import { pool } from '../src/db.js';
import bcrypt from 'bcrypt';

const rounds = Number(process.env.BCRYPT_ROUNDS || 10);

export default async function handler(req, res) {
  if (req.method === 'POST' && req.url.endsWith('/register')) {
    const { username, password, role = 'Volunteer' } = req.body;
    if (!username || !password) return res.status(400).json({ error: 'Missing credentials' });

    try {
      const hash = await bcrypt.hash(password, rounds);
      const result = await pool.query(
        'INSERT INTO app_user (username, password_hash, role) VALUES ($1, $2, $3) RETURNING user_id, username, role',
        [username, hash, role]
      );
      res.status(201).json(result.rows[0]);
    } catch (err) {
      if (err.code === '23505') return res.status(409).json({ error: 'Username already exists' });
      res.status(500).json({ error: 'Registration failed' });
    }
  } else if (req.method === 'POST' && req.url.endsWith('/login')) {
    const { username, password } = req.body;
    if (!username || !password) return res.status(400).json({ error: 'Missing credentials' });

    const result = await pool.query(
      'SELECT user_id, username, password_hash, role FROM app_user WHERE username = $1',
      [username]
    );
    const user = result.rows[0];
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });

    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) return res.status(401).json({ error: 'Invalid credentials' });

    res.json({ user_id: user.user_id, username: user.username, role: user.role });
  } else {
    res.status(405).json({ error: 'Method not allowed' });
  }
}