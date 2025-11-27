import dotenv from 'dotenv';
import app from './app.js';
import { pool } from './db.js';

dotenv.config();

const port = process.env.PORT || 4000;

pool.query('SELECT 1').then(() => {
  app.listen(port, () => {
    console.log(`API running at http://localhost:${port}`);
  });
}).catch(err => {
  console.error('Database connection failed:', err);
  process.exit(1);
});
