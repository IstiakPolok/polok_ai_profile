import React, { useState } from "react";
import { Menu, X } from "lucide-react";

export const Header = ({ currentSection, onNavigate }) => {
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);

  const navItems = [
    { label: "Home", index: 0 },
    { label: "About me", index: 1 },
    { label: "Experience", index: 2 },
    { label: "Education", index: 3 },
    { label: "Skills", index: 4 },
    { label: "Projects", index: 5 },
    { label: "Contact me", index: 6 },
  ];

  const handleNav = (index) => {
    onNavigate(index);
    setIsDrawerOpen(false);
  };

  return (
    <>
      <header className={`site-header ${currentSection === 0 ? "hero-header" : ""}`}>
        <div className="brand-logo" onClick={() => handleNav(0)}>
          POLOK
        </div>

        <nav className="nav-links">
          {navItems.map((item) => (
            <span
              key={item.label}
              className={`nav-link ${currentSection === item.index ? "active" : ""}`}
              onClick={() => handleNav(item.index)}
            >
              {item.label}
            </span>
          ))}
        </nav>

        <button
          className="mobile-menu-btn"
          onClick={() => setIsDrawerOpen(true)}
          aria-label="Open menu"
        >
          <Menu size={26} />
        </button>
      </header>

      {/* Mobile Drawer */}
      {isDrawerOpen && (
        <>
          <div
            className="drawer-overlay"
            onClick={() => setIsDrawerOpen(false)}
          />
          <div className="mobile-drawer">
            <div className="mobile-drawer-header">
              <span className="brand-logo" onClick={() => handleNav(0)}>
                POLOK
              </span>
              <button
                className="mobile-menu-btn"
                onClick={() => setIsDrawerOpen(false)}
                aria-label="Close menu"
              >
                <X size={26} />
              </button>
            </div>
            <div className="mobile-drawer-links">
              {navItems.map((item) => (
                <span
                  key={item.label}
                  className={`mobile-nav-link ${currentSection === item.index ? "active" : ""}`}
                  onClick={() => handleNav(item.index)}
                >
                  {item.label}
                </span>
              ))}
            </div>
          </div>
        </>
      )}
    </>
  );
};
