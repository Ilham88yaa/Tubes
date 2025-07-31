import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
  useLocation
} from "react-router-dom";
import AdminLogin from "./pages/admin_login";
import Dashboard from "./pages/dashboard";

// Komponen proteksi halaman
function ProtectedRoute({ children }) {
  const token = localStorage.getItem("adminToken");
  const location = useLocation();

  if (!token) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children;
}

// Komponen login wrapper agar redirect jika sudah login
function LoginRoute() {
  const token = localStorage.getItem("adminToken");

  if (token) {
    return <Navigate to="/" replace />;
  }

  return <AdminLogin />;
}

function App() {
  return (
    <Router>
      <Routes>
        {/* Login route */}
        <Route path="/login" element={<LoginRoute />} />

        {/* Dashboard */}
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
