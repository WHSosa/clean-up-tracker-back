import { Router } from 'express';
const router = Router();

router.get('/', (_req, res) => {
  res.json({ message: 'Reports endpoint working' });
});

export default router;
