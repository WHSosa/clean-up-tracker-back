import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

import authRouter from './routes/auth.js';
import eventsRouter from './routes/events.js';
import volunteersRouter from './routes/volunteers.js';
import wasteRouter from './routes/waste.js';
import reportsRouter from './routes/reports.js';
import photosRouter from './routes/photos.js';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRouter);
app.use('/api/events', eventsRouter);
app.use('/api/volunteers', volunteersRouter);
app.use('/api/waste', wasteRouter);
app.use('/api/reports', reportsRouter);
app.use('/api/photos', photosRouter);

// Health check
app.get('/api/health', (_req, res) => res.json({ ok: true }));

export default app;

