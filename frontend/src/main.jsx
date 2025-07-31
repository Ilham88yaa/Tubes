// main.jsx
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';

// Pastikan hanya render sekali
const rootElement = document.getElementById('root');
const root = createRoot(rootElement);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
