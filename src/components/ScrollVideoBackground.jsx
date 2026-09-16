import React, { useEffect, useRef, useState } from "react";

/**
 * ScrollVideoBackground
 *
 * Provides buttery-smooth, hardware-accelerated video scrubbing:
 * 1. Preloads the video buffer in memory via Blob URL for instantaneous seeking.
 * 2. Uses fastSeek() if supported by the browser GPU decoder, with graceful fallback to currentTime.
 * 3. Respects browser 'seeking' / 'seeked' pipeline to avoid queue-flooding and stutter.
 * 4. Renders on an accelerated layer with will-change and transform3d.
 */
export const ScrollVideoBackground = ({ scrollProgress }) => {
  const videoRef = useRef(null);
  const targetTimeRef = useRef(0);
  const isSeekingRef = useRef(false);
  const pendingTargetRef = useRef(null);
  const [videoSrc, setVideoSrc] = useState("/video/bgvideo.mp4");
  const [isLoaded, setIsLoaded] = useState(false);

  // Preload entire video as a local blob so that scrubbing requires 0 network latency & 0 disk reads
  useEffect(() => {
    let active = true;
    fetch("/video/bgvideo.mp4")
      .then((res) => {
        if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
        return res.blob();
      })
      .then((blob) => {
        if (!active) return;
        const blobUrl = URL.createObjectURL(blob);
        setVideoSrc(blobUrl);
      })
      .catch((err) => {
        console.warn("Video blob preload error (using direct URL fallback):", err);
        setVideoSrc("/video/bgvideo.mp4");
      });

    return () => {
      active = false;
    };
  }, []);

  // Update target scrub time immediately upon scroll
  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    const duration = video.duration && !isNaN(video.duration) && video.duration > 0 ? video.duration : 24.0;
    targetTimeRef.current = scrollProgress * duration;

    // Trigger seek
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

    const onLoadedMetadata = () => {
      video.pause();
      setIsLoaded(true);
      targetTimeRef.current = scrollProgress * video.duration;
      requestSeek(targetTimeRef.current);
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
    video.addEventListener("seeked", onSeeked);

    return () => {
      video.removeEventListener("loadedmetadata", onLoadedMetadata);
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
