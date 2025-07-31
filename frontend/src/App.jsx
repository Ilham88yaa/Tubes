import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import AdminLogin from "./pages/admin_login";   // halaman login admin
import Dashboard from "./pages/dashboard";       // dashboard utama
import { getAllRekamMedis } from "./services/rekam_service"; // jika digunakan

function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('adminToken'); // ambil token dari localStorage
    setLoggedIn(!!token); // true jika token ada
  }, []);

  return (
    <Router>
      <Routes>
        {/* Route Login */}
        <Route
          path="/login"
          element={
            loggedIn
              ? <Navigate to="/" />
              : <AdminLogin onLoginSuccess={() => setLoggedIn(true)} />
          }
        />

        {/* Route Dashboard */}
        <Route
          path="/"
          element={
            loggedIn
              ? <Dashboard />
              : <Navigate to="/login" />
          }
        />

        {/* Route fallback */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;
