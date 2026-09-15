(() => {
	const apiUrl = "https://api.github.com/repos/lily-studios/Reactily/releases/latest";
	const latestReleaseUrl = "https://github.com/lily-studios/Reactily/releases/latest";
	const cacheKey = "reactily-latest-release";
	const cacheDuration = 60 * 60 * 1000;

	function findReleaseLinks() {
		return Array.from(
			document.querySelectorAll(
				'a[href="https://github.com/lily-studios/Reactily/releases/latest"], a[href^="https://github.com/lily-studios/Reactily/releases/tag/"]'
			)
		);
	}

	function applyRelease(release) {
		if (!release || typeof release.tag_name !== "string") return;

		const label = `Release ${release.tag_name}`;
		const href =
			typeof release.html_url === "string" && release.html_url.length > 0
				? release.html_url
				: latestReleaseUrl;

		for (const link of findReleaseLinks()) {
			link.textContent = label;
			link.href = href;
			link.setAttribute("aria-label", label);
		}
	}

	function readCache() {
		try {
			const raw = localStorage.getItem(cacheKey);
			if (!raw) return null;

			const cached = JSON.parse(raw);
			if (!cached || typeof cached.savedAt !== "number") return null;
			if (Date.now() - cached.savedAt > cacheDuration) return null;

			return cached.release ?? null;
		} catch {
			return null;
		}
	}

	function writeCache(release) {
		try {
			localStorage.setItem(
				cacheKey,
				JSON.stringify({
					savedAt: Date.now(),
					release,
				})
			);
		} catch {
			// Caching is optional.
		}
	}

	async function loadLatestRelease() {
		const cached = readCache();

		if (cached) {
			applyRelease(cached);
			return;
		}

		try {
			const response = await fetch(apiUrl, {
				headers: {
					Accept: "application/vnd.github+json",
				},
			});

			if (!response.ok) return;

			const release = await response.json();

			if (
				!release ||
				typeof release.tag_name !== "string" ||
				release.tag_name.length === 0
			) {
				return;
			}

			writeCache(release);
			applyRelease(release);
		} catch {
			// Keep the fallback "Release" label and /releases/latest link.
		}
	}

	function refreshReleaseButton() {
		const cached = readCache();

		if (cached) {
			applyRelease(cached);
		}

		void loadLatestRelease();
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", refreshReleaseButton, {
			once: true,
		});
	} else {
		refreshReleaseButton();
	}

})();
