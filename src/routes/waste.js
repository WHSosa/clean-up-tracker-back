import { Router } from 'express';
const router = Router();

router.get('/', (_req, res) => {
  res.json({ message: 'Waste endpoint working' });
});

export default router;
