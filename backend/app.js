const express = require('express');
const cors = require('cors');

const app = express();

// Enable CORS for frontend communication
app.use(cors());
app.use(express.json());

// In-memory task database
let tasks = [];
let taskId = 1;

// ========== TASK API ENDPOINTS ==========

// GET all tasks
app.get('/tasks', (req, res) => {
  console.log('📋 GET /tasks - Returning', tasks.length, 'tasks');
  res.json(tasks);
});

// ADD new task (POST)
app.post('/tasks', (req, res) => {
  const { text } = req.body;
  if (!text) {
    return res.status(400).json({ error: 'Task text is required' });
  }
  const task = {
    id: taskId++,
    text: text,
    completed: false,
    createdAt: new Date().toISOString()
  };
  tasks.push(task);
  console.log('✅ Added task:', task);
  res.json(task);
});

// UPDATE task completion
app.put('/tasks/:id', (req, res) => {
  const task = tasks.find(t => t.id == req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  task.completed = !task.completed;
  console.log('🔄 Updated task:', task);
  res.json(task);
});

// DELETE task
app.delete('/tasks/:id', (req, res) => {
  const initialLength = tasks.length;
  tasks = tasks.filter(t => t.id != req.params.id);
  console.log('🗑️ Deleted task. Remaining:', tasks.length);
  res.json({ message: 'Task deleted', remaining: tasks.length });
});

// DELETE all tasks
app.delete('/tasks', (req, res) => {
  tasks = [];
  console.log('🧹 Cleared all tasks');
  res.json({ message: 'All tasks deleted' });
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    taskCount: tasks.length,
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(3000, () => {
  console.log('\n=== Task Manager Backend ===');
  console.log('✅ Server running on port 3000');
  console.log('🔗 CORS enabled for all origins');
  console.log('📊 API Routes:');
  console.log('   GET    /tasks - Get all tasks');
  console.log('   POST   /tasks - Add new task');
  console.log('   PUT    /tasks/:id - Toggle task completion');
  console.log('   DELETE /tasks/:id - Delete task');
  console.log('   GET    /health - Health check\n');
});
