import React from "react";
import Link from "@docusaurus/Link";
import Layout from "@theme/Layout";

const features = [
	{
		title: "Typed and predictable",
		body: "Reactily is built around strict Luau contracts, typed Roblox UI creators, stable component behavior, and explicit public APIs.",
	},
	{
		title: "Reactive without background noise",
		body: "State, stores, bindings, hooks, and animation systems are designed around change-only updates and idle-safe runtime work.",
	},
	{
		title: "Composable and extensible",
		body: "Build small components and combine roots, hooks, signals, bindings, themes, virtualization, pools, transitions, and diagnostics as needed.",
	},
];

export default function Home() {
	return (
		<Layout
			title="Reactily"
			description="Typed React-inspired UI framework for Roblox Luau"
		>
			<main>
				<section className="reactilyHero">
					<div className="reactilyContainer reactilyHeroInner">
						<p className="reactilyEyebrow">Lily Studios</p>
						<h1>Reactily</h1>
						<p className="reactilyTagline">
							A typed, React-inspired interface framework for Roblox Luau.
						</p>

						<div className="reactilyHeroActions">
							<Link
								className="button button--primary button--lg"
								to="/docs/getting-started"
							>
								Get Started
							</Link>

							<Link
								className="button button--secondary button--lg"
								to="/api"
							>
								API Documentation
							</Link>
						</div>
					</div>
				</section>

				<section className="reactilyNoticeSection">
					<div className="reactilyContainer">
						<div className="reactilyNotice">
							<strong>Documentation</strong>
							<span>
								Use the guides to learn Reactily, then jump into the API reference
								when you need exact function signatures and examples.
							</span>
						</div>
					</div>
				</section>

				<section className="reactilyFeatures">
					<div className="reactilyContainer reactilyFeatureGrid">
						{features.map((feature) => (
							<article key={feature.title} className="reactilyFeature">
								<h2>{feature.title}</h2>
								<p>{feature.body}</p>
							</article>
						))}
					</div>
				</section>

				<section className="reactilyAbout">
					<div className="reactilyContainer reactilyAboutInner">
						<div>
							<p className="reactilySectionLabel">Designed for Roblox UI</p>
							<h2>Small primitives, explicit ownership.</h2>
						</div>

						<div className="reactilyAboutCopy">
							<p>
								Reactily gives Roblox developers a component-driven way to build
								interfaces while preserving explicit lifecycle control. Roots own
								rendered trees, Reactily resources use <code>delete()</code>, and
								Roblox-owned resources keep their normal Roblox lifecycle.
							</p>

							<p>
								The public API is dot-based and built for strict Luau. The framework
								favors keyed reconciliation, stable hook order, change-only writes,
								and runtime work that becomes dormant when nothing needs updating.
							</p>

							<Link to="/docs/intro" className="reactilyTextLink">
								Tell me more →
							</Link>
						</div>
					</div>
				</section>
			</main>
		</Layout>
	);
}
