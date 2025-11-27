export default async function handler(req, res) {
  if (req.method === 'GET') {
    res.status(200).json({ message: 'Reports endpoint working' });
  } else {
    res.status(405).json({ error: 'Method not allowed' });
  }
}