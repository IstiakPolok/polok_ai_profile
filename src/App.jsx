import React, { useState, useEffect, useRef } from "react";
import { profileData } from "./profileData";
import { Header } from "./components/Header";
import { ScrollVideoBackground } from "./components/ScrollVideoBackground";
import {
  Globe,
  Mail,
  Phone,
  MapPin,
  FileDown,
  Briefcase,
  GraduationCap,
  ChevronDown,
  ExternalLink,
  Code2,
} from "lucide-react";
import { GithubIcon, LinkedinIcon } from "./components/SocialIcons";

export function App() {
  const [currentSection, setCurrentSection] = useState(0);
  const [scrollProgress, setScrollProgress] = useState(0);
  const containerRef = useRef(null);
  const totalSections = 7;

  // Title swap animation index in Hero
  const [titleIndex, setTitleIndex] = useState(0);
  const titles = [
    "Flutter Developer",
    "Mobile Application Engineer",
    "Cross-Platform Specialist",
    "Dart Enthusiast",
  ];

  useEffect(() => {
    const interval = setInterval(() => {
      setTitleIndex((prev) => (prev + 1) % titles.length);
    }, 2800);
    return () => clearInterval(interval);
  }, [titles.length]);

  // Handle scroll progress and update currentSection & video scrub progress
  const handleScroll = (e) => {
    const { scrollTop, scrollHeight, clientHeight } = e.target;
    const maxScroll = scrollHeight - clientHeight;
    if (maxScroll <= 0) return;

    const progress = Math.min(1, Math.max(0, scrollTop / maxScroll));
    setScrollProgress(progress);

    const sectionIndex = Math.round(scrollTop / clientHeight);
    setCurrentSection(sectionIndex);
  };

  // Smooth jump to section
  const scrollToSection = (index) => {
    if (!containerRef.current) return;
    const targetY = index * containerRef.current.clientHeight;
    containerRef.current.scrollTo({
      top: targetY,
      behavior: "smooth",
    });
    setCurrentSection(index);
  };

  return (
    <div style={{ position: "relative", width: "100vw", height: "100vh", overflow: "hidden" }}>
      {/* Native 60 FPS Hardware-Accelerated Video Background */}
      <ScrollVideoBackground scrollProgress={scrollProgress} />

      {/* Fixed Header */}
      <Header currentSection={currentSection} onNavigate={scrollToSection} />

      {/* Side Dot Navigation Indicators */}
      <div className="section-dots" aria-label="Section indicators">
        {Array.from({ length: totalSections }).map((_, idx) => (
          <button
            key={idx}
            className={`section-dot ${currentSection === idx ? "active" : ""}`}
            onClick={() => scrollToSection(idx)}
            aria-label={`Go to section ${idx + 1}`}
          />
        ))}
      </div>

      {/* Main Snap Container */}
      <main
        ref={containerRef}
        className="snap-container"
        onScroll={handleScroll}
        style={{ zIndex: 10 }}
      >
        {/* SECTION 0: HERO */}
        <section className="section-view" id="hero">
          <div className="section-content-box">
            <span
              style={{
                fontSize: "14px",
                letterSpacing: "2px",
                textTransform: "uppercase",
                color: "var(--primary-light)",
                fontWeight: 600,
                marginBottom: "8px",
              }}
            >
              Hello, I am
            </span>

            <h1
              style={{
                fontSize: "clamp(36px, 5vw, 54px)",
                fontWeight: 800,
                color: "#FFFFFF",
                marginBottom: "12px",
                lineHeight: 1.15,
              }}
            >
              {profileData.name}
            </h1>

            {/* Dynamic Swapping Title */}
            <div
              style={{
                fontSize: "clamp(20px, 3vw, 28px)",
                color: "var(--primary-light)",
                fontWeight: 600,
                minHeight: "40px",
                marginBottom: "20px",
                transition: "all 0.3s ease",
              }}
            >
              {titles[titleIndex]}
            </div>

            <p
              style={{
                fontSize: "15px",
                color: "var(--text-muted)",
                lineHeight: 1.7,
                maxWidth: "640px",
                marginBottom: "32px",
              }}
            >
              {profileData.bio}
            </p>

            {/* CTA Buttons */}
            <div
              style={{
                display: "flex",
                gap: "16px",
                flexWrap: "wrap",
                justifyContent: "flex-end",
              }}
            >
              <a
                href={profileData.cvUrl}
                target="_blank"
                rel="noreferrer"
                className="btn-primary"
              >
                <FileDown size={18} />
                Download CV
              </a>
              <button
                className="btn-outline"
                onClick={() => scrollToSection(6)}
              >
                Contact Me
              </button>
            </div>

            {/* Social Icons */}
            <div className="social-links">
              <a
                href={profileData.socialLinks.github}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="GitHub"
              >
                <GithubIcon size={20} />
              </a>
              <a
                href={profileData.socialLinks.linkedin}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="LinkedIn"
              >
                <LinkedinIcon size={20} />
              </a>
              <a
                href={profileData.socialLinks.portfolio}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="Portfolio"
              >
                <Globe size={20} />
              </a>
            </div>

            {/* Stats Row */}
            <div className="glass-card stats-card">
              {profileData.stats.map((st, idx) => (
                <div key={idx} className="stat-item">
                  <span className="stat-val">{st.value}</span>
                  <span className="stat-lbl">{st.label}</span>
                </div>
              ))}
            </div>

            {/* Scroll down prompt */}
            <div
              onClick={() => scrollToSection(1)}
              style={{
                marginTop: "32px",
                display: "flex",
                alignItems: "center",
                gap: "6px",
                color: "var(--text-muted)",
                fontSize: "13px",
                cursor: "pointer",
              }}
            >
              <span>Scroll to explore</span>
              <ChevronDown size={16} />
            </div>
          </div>
        </section>

        {/* SECTION 1: ABOUT ME */}
        <section className="section-view" id="about">
          <div className="section-content-box">
            <h2 className="section-title">About Me</h2>
            <p className="section-subtitle">A brief overview of who I am and what I do</p>

            <div className="glass-card" style={{ width: "100%", marginBottom: "24px" }}>
              <p style={{ color: "#E0E0E0", lineHeight: 1.8, fontSize: "15px", marginBottom: "16px" }}>
                {profileData.bio}
              </p>
              <div
                style={{
                  display: "grid",
                  gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
                  gap: "16px",
                  borderTop: "1px solid rgba(8, 88, 156, 0.25)",
                  paddingTop: "20px",
                  marginTop: "16px",
                }}
              >
                <div>
                  <span style={{ color: "var(--primary-light)", fontSize: "12px", display: "block" }}>
                    Location
                  </span>
                  <span style={{ color: "#FFFFFF", fontSize: "14px", fontWeight: 500 }}>
                    {profileData.location}
                  </span>
                </div>
                <div>
                  <span style={{ color: "var(--primary-light)", fontSize: "12px", display: "block" }}>
                    Email
                  </span>
                  <span style={{ color: "#FFFFFF", fontSize: "14px", fontWeight: 500 }}>
                    {profileData.email}
                  </span>
                </div>
                <div>
                  <span style={{ color: "var(--primary-light)", fontSize: "12px", display: "block" }}>
                    Phone
                  </span>
                  <span style={{ color: "#FFFFFF", fontSize: "14px", fontWeight: 500 }}>
                    {profileData.phone}
                  </span>
                </div>
              </div>
            </div>

            <a
              href={profileData.cvUrl}
              target="_blank"
              rel="noreferrer"
              className="btn-primary"
            >
              <FileDown size={18} />
              Download Full Resume
            </a>
          </div>
        </section>

        {/* SECTION 2: EXPERIENCE */}
        <section className="section-view" id="experience">
          <div className="section-content-box">
            <h2 className="section-title">Work Experience</h2>
            <p className="section-subtitle">My professional journey and track record</p>

            <div style={{ display: "flex", flexDirection: "column", gap: "18px", width: "100%" }}>
              {profileData.workExperience.map((exp, idx) => (
                <div key={idx} className="glass-card" style={{ width: "100%" }}>
                  <div
                    style={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                      marginBottom: "6px",
                      flexWrap: "wrap",
                      gap: "8px",
                    }}
                  >
                    <span
                      style={{
                        color: "var(--primary-light)",
                        fontSize: "12px",
                        background: "rgba(8, 88, 156, 0.2)",
                        padding: "4px 10px",
                        borderRadius: "12px",
                        border: "1px solid rgba(8, 88, 156, 0.4)",
                      }}
                    >
                      {exp.duration}
                    </span>
                    <h3 style={{ fontSize: "18px", color: "#FFFFFF", fontWeight: 700 }}>
                      {exp.position}
                    </h3>
                  </div>
                  <div style={{ color: "var(--primary-light)", fontSize: "14px", fontWeight: 600, marginBottom: "8px" }}>
                    {exp.company}
                  </div>
                  <p style={{ color: "var(--text-muted)", fontSize: "14px", lineHeight: 1.6 }}>
                    {exp.description}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* SECTION 3: EDUCATION */}
        <section className="section-view" id="education">
          <div className="section-content-box">
            <h2 className="section-title">Education</h2>
            <p className="section-subtitle">Academic foundations and achievements</p>

            <div style={{ display: "flex", flexDirection: "column", gap: "18px", width: "100%" }}>
              {profileData.education.map((edu, idx) => (
                <div key={idx} className="glass-card" style={{ width: "100%" }}>
                  <div
                    style={{
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "center",
                      marginBottom: "6px",
                      flexWrap: "wrap",
                      gap: "8px",
                    }}
                  >
                    <span
                      style={{
                        color: "var(--primary-light)",
                        fontSize: "12px",
                        background: "rgba(8, 88, 156, 0.2)",
                        padding: "4px 10px",
                        borderRadius: "12px",
                        border: "1px solid rgba(8, 88, 156, 0.4)",
                      }}
                    >
                      {edu.duration}
                    </span>
                    <h3 style={{ fontSize: "18px", color: "#FFFFFF", fontWeight: 700 }}>
                      {edu.degree}
                    </h3>
                  </div>
                  <div style={{ color: "var(--primary-light)", fontSize: "14px", fontWeight: 600, marginBottom: "8px" }}>
                    {edu.institution}
                  </div>
                  <p style={{ color: "var(--text-muted)", fontSize: "14px" }}>
                    {edu.description}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* SECTION 4: SKILLS */}
        <section className="section-view" id="skills">
          <div className="section-content-box">
            <h2 className="section-title">Technical Skills</h2>
            <p className="section-subtitle">Tools, frameworks, and technologies I specialize in</p>

            <div style={{ display: "flex", flexDirection: "column", gap: "18px", width: "100%" }}>
              {Object.entries(profileData.skills).map(([category, items]) => (
                <div key={category} className="glass-card" style={{ width: "100%", padding: "18px 22px" }}>
                  <h3
                    style={{
                      fontSize: "15px",
                      color: "var(--primary-light)",
                      fontWeight: 700,
                      marginBottom: "12px",
                      textTransform: "uppercase",
                      letterSpacing: "1px",
                    }}
                  >
                    {category}
                  </h3>
                  <div
                    style={{
                      display: "flex",
                      flexWrap: "wrap",
                      gap: "8px",
                      justifyContent: "flex-end",
                    }}
                  >
                    {items.map((skill) => (
                      <span
                        key={skill}
                        style={{
                          background: "rgba(8, 88, 156, 0.22)",
                          border: "1px solid rgba(8, 88, 156, 0.45)",
                          color: "#FFFFFF",
                          padding: "6px 14px",
                          borderRadius: "20px",
                          fontSize: "13px",
                          fontWeight: 500,
                          transition: "all 0.2s ease",
                        }}
                      >
                        {skill}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* SECTION 5: PROJECTS */}
        <section className="section-view" id="projects">
          <div className="section-content-box">
            <h2 className="section-title">Selected Projects</h2>
            <p className="section-subtitle">Featured production mobile apps and deployment solutions</p>

            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))",
                gap: "16px",
                width: "100%",
              }}
            >
              {profileData.projects.map((proj, idx) => (
                <div
                  key={idx}
                  className="glass-card"
                  style={{
                    display: "flex",
                    flexDirection: "column",
                    justifyContent: "space-between",
                    minHeight: "150px",
                  }}
                >
                  <div>
                    <h3
                      style={{
                        fontSize: "17px",
                        color: "#FFFFFF",
                        fontWeight: 700,
                        marginBottom: "8px",
                      }}
                    >
                      {proj.name}
                    </h3>
                    <p
                      style={{
                        color: "var(--text-muted)",
                        fontSize: "13px",
                        lineHeight: 1.6,
                        marginBottom: "14px",
                      }}
                    >
                      {proj.description}
                    </p>
                  </div>

                  <div
                    style={{
                      fontSize: "11px",
                      color: "var(--primary-light)",
                      borderTop: "1px solid rgba(8, 88, 156, 0.2)",
                      paddingTop: "10px",
                      fontWeight: 600,
                    }}
                  >
                    {proj.technologies}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* SECTION 6: CONTACT & FOOTER */}
        <section className="section-view" id="contact">
          <div className="section-content-box">
            <h2 className="section-title">Get In Touch</h2>
            <p className="section-subtitle">
              Have a project in mind or want to collaborate? Send me a message!
            </p>

            <div className="glass-card" style={{ width: "100%", marginBottom: "28px" }}>
              <div
                style={{
                  display: "flex",
                  flexDirection: "column",
                  gap: "18px",
                  marginBottom: "24px",
                }}
              >
                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-end", gap: "12px" }}>
                  <a
                    href={`mailto:${profileData.email}`}
                    style={{ color: "#FFFFFF", textDecoration: "none", fontSize: "15px" }}
                  >
                    {profileData.email}
                  </a>
                  <Mail size={18} color="var(--primary-light)" />
                </div>

                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-end", gap: "12px" }}>
                  <a
                    href={`tel:${profileData.phone}`}
                    style={{ color: "#FFFFFF", textDecoration: "none", fontSize: "15px" }}
                  >
                    {profileData.phone}
                  </a>
                  <Phone size={18} color="var(--primary-light)" />
                </div>

                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-end", gap: "12px" }}>
                  <span style={{ color: "#FFFFFF", fontSize: "15px" }}>
                    {profileData.location}
                  </span>
                  <MapPin size={18} color="var(--primary-light)" />
                </div>
              </div>

              <div
                style={{
                  borderTop: "1px solid rgba(8, 88, 156, 0.25)",
                  paddingTop: "20px",
                  display: "flex",
                  justifyContent: "flex-end",
                  gap: "14px",
                }}
              >
                <a
                  href={`mailto:${profileData.email}`}
                  className="btn-primary"
                >
                  <Mail size={16} />
                  Send an Email
                </a>
              </div>
            </div>

            <div className="social-links" style={{ marginBottom: "24px" }}>
              <a
                href={profileData.socialLinks.github}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="GitHub"
              >
                <GithubIcon size={20} />
              </a>
              <a
                href={profileData.socialLinks.linkedin}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="LinkedIn"
              >
                <LinkedinIcon size={20} />
              </a>
              <a
                href={profileData.socialLinks.portfolio}
                target="_blank"
                rel="noreferrer"
                className="social-btn"
                aria-label="Portfolio"
              >
                <Globe size={20} />
              </a>
            </div>

            <footer
              style={{
                color: "var(--text-muted)",
                fontSize: "12px",
                borderTop: "1px solid rgba(255, 255, 255, 0.1)",
                paddingTop: "16px",
                width: "100%",
              }}
            >
              © {new Date().getFullYear()} {profileData.name}. All rights reserved. Built with React & Vite.
            </footer>
          </div>
        </section>
      </main>
    </div>
  );
}

export default App;
