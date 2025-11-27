import { Router } from 'express';
const router = Router();

router.get('/', (_req, res) => {
  res.json({ message: 'Volunteers endpoint working' });
});

export default router;
