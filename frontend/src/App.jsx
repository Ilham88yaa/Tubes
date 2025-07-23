import { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import AdminLogin from "./pages/admin_login";
import Dashboard from "./pages/dashboard";
import { getAllRekamMedis } from "./services/rekam_service";


function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('adminToken');
    setLoggedIn(!!token);
  }, []);

  return (
    <Router>
      <Routes>
        {/* Route login */}
        <Route path="/login" element={
          loggedIn ? <Navigate to="/" /> : <AdminLogin onLoginSuccess={() => setLoggedIn(true)} />
        } />

        {/* Route dashboard */}
        <Route path="/" element={
          loggedIn ? <Dashboard /> : <Navigate to="/login" />
        } />
        
        {/* Redirect unknown routes */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;
