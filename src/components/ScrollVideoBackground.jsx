import React, { useEffect, useRef, useState } from "react";

let cachedVideoBlobUrl = null;

/**
 * ScrollVideoBackground
 *
 * Provides buttery-smooth, hardware-accelerated video scrubbing:
 * 1. Caches the 2.8MB video in browser RAM/Blob URL so seeking produces 0 network or disk operations.
 * 2. Uses requestAnimationFrame throttled seeking to match display refresh rate (60-144 Hz).
 * 3. Gracefully notifies parent when buffer is ready for zero-lag smooth experience.
 */
export const ScrollVideoBackground = ({ scrollProgress, onReady }) => {
  const videoRef = useRef(null);
  const targetTimeRef = useRef(0);
  const isSeekingRef = useRef(false);
  const pendingTargetRef = useRef(null);
  const [videoSrc, setVideoSrc] = useState(cachedVideoBlobUrl || "/video/bgvideo.mp4");
  const [isLoaded, setIsLoaded] = useState(false);

  // Preload and cache entire video as a local blob in memory
  useEffect(() => {
    let active = true;
    if (cachedVideoBlobUrl) {
      setVideoSrc(cachedVideoBlobUrl);
      return;
    }

    fetch("/video/bgvideo.mp4")
      .then((res) => {
        if (!res.ok) throw new Error("Network fetch failed");
        return res.blob();
      })
      .then((blob) => {
        if (!active) return;
        cachedVideoBlobUrl = URL.createObjectURL(blob);
        setVideoSrc(cachedVideoBlobUrl);
      })
      .catch((err) => {
        console.warn("Video blob memory caching fallback to direct url:", err);
      });

    return () => {
      active = false;
    };
  }, []);

  // Update target scrub time immediately upon scroll
  useEffect(() => {
    const video = videoRef.current;
    if (!video || isNaN(video.duration) || video.duration === 0) return;

    targetTimeRef.current = scrollProgress * video.duration;

    // Trigger immediate seek if not currently seeking
    requestSeek(targetTimeRef.current);
  }, [scrollProgress]);

  // Handle hardware decoder seek queue
  const requestSeek = (targetTime) => {
    const video = videoRef.current;
    if (!video || isNaN(video.duration) || video.duration === 0) return;

    const boundedTime = Math.max(0, Math.min(video.duration - 0.001, targetTime));

    if (isSeekingRef.current) {
      // Store the most recent target to apply immediately when the current seek finishes
      pendingTargetRef.current = boundedTime;
      return;
    }

    // Only seek if distance is meaningful to avoid redundant decoder interrupts
    if (Math.abs(video.currentTime - boundedTime) < 0.03) {
      return;
    }

    isSeekingRef.current = true;

    // Use fastSeek (hardware keyframe seeking) if supported, else direct currentTime
    if (typeof video.fastSeek === "function") {
      video.fastSeek(boundedTime);
    } else {
      video.currentTime = boundedTime;
    }
  };

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    const onCanPlayThrough = () => {
      setIsLoaded(true);
      if (typeof onReady === "function") {
        onReady();
      }
    };

    const onLoadedMetadata = () => {
      video.pause();
      targetTimeRef.current = scrollProgress * video.duration;
      requestSeek(targetTimeRef.current);
      // If already ready to play all frames without buffering
      if (video.readyState >= 4) {
        setIsLoaded(true);
        if (typeof onReady === "function") {
          onReady();
        }
      }
    };

    const onSeeked = () => {
      isSeekingRef.current = false;
      if (pendingTargetRef.current !== null) {
        const next = pendingTargetRef.current;
        pendingTargetRef.current = null;
        requestSeek(next);
      }
    };

    video.addEventListener("loadedmetadata", onLoadedMetadata);
    video.addEventListener("canplaythrough", onCanPlayThrough);
    video.addEventListener("seeked", onSeeked);

    return () => {
      video.removeEventListener("loadedmetadata", onLoadedMetadata);
      video.removeEventListener("canplaythrough", onCanPlayThrough);
      video.removeEventListener("seeked", onSeeked);
    };
  }, [scrollProgress]);

  // Continuous fallback RAF loop to ensure smooth catch-up
  useEffect(() => {
    let animId;
    const tick = () => {
      const video = videoRef.current;
      if (video && !isSeekingRef.current && isLoaded && !isNaN(video.duration)) {
        const diff = targetTimeRef.current - video.currentTime;
        if (Math.abs(diff) > 0.05) {
          requestSeek(targetTimeRef.current);
        }
      }
      animId = requestAnimationFrame(tick);
    };
    animId = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(animId);
  }, [isLoaded]);

  return (
    <div className="video-bg-container">
      <video
        ref={videoRef}
        src={videoSrc}
        playsInline
        muted
        autoPlay={false}
        preload="auto"
        className="video-bg"
        style={{
          willChange: "transform",
          transform: "translate3d(0, 0, 0)",
          backfaceVisibility: "hidden",
        }}
      />
    </div>
  );
};
