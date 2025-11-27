import dotenv from 'dotenv';
import app from './src/app.js';
import { pool } from './src/db.js';

dotenv.config();

const port = process.env.PORT || 4000;


  app.listen(port, () => {
    console.log(`API running at http://localhost:${port}`);
  });