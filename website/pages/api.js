import React from "react";
import Link from "@docusaurus/Link";
import Layout from "@theme/Layout";

export default function Api() {
	return (
		<Layout
			title="API Reference"
			description="Complete Reactily public API reference"
		>
			<main className="reactilyApiPage">
				<div className="reactilyContainer">
					<p className="reactilyEyebrow">Reference</p>
					<h1>API Reference</h1>
					<p className="reactilyApiIntro">
						Browse Reactily's public API by system. Every function has its own
						reference page with its signature, parameters, return information,
						usage examples, and behavior notes.
					</p>

					<div className="reactilyApiGrid">
			<Link
				key="advanced-components"
				className="reactilyApiCard"
				to="/docs/api/advanced-components/create-context-provider"
			>
				<strong>Advanced Components</strong>
				<span>Browse advanced components APIs.</span>
			</Link>
			<Link
				key="animation"
				className="reactilyApiCard"
				to="/docs/api/animation/create-animation-delay"
			>
				<strong>Animation & Transitions</strong>
				<span>Browse animation & transitions APIs.</span>
			</Link>
			<Link
				key="bindings"
				className="reactilyApiCard"
				to="/docs/api/bindings/bind-attribute"
			>
				<strong>Bindings</strong>
				<span>Browse bindings APIs.</span>
			</Link>
			<Link
				key="diagnostics"
				className="reactilyApiCard"
				to="/docs/api/diagnostics/create-diagnostics"
			>
				<strong>Diagnostics & Strict Mode</strong>
				<span>Browse diagnostics & strict mode APIs.</span>
			</Link>
			<Link
				key="focus"
				className="reactilyApiCard"
				to="/docs/api/focus/clear-focus"
			>
				<strong>Focus & Interaction</strong>
				<span>Browse focus & interaction APIs.</span>
			</Link>
			<Link
				key="hooks"
				className="reactilyApiCard"
				to="/docs/api/hooks/use-attribute"
			>
				<strong>Hooks</strong>
				<span>Browse hooks APIs.</span>
			</Link>
			<Link
				key="package"
				className="reactilyApiCard"
				to="/docs/api/package/get-version"
			>
				<strong>Package</strong>
				<span>Browse package APIs.</span>
			</Link>
			<Link
				key="pools-runtime"
				className="reactilyApiCard"
				to="/docs/api/pools-runtime/create-instance-pool"
			>
				<strong>Pools & Runtime</strong>
				<span>Browse pools & runtime APIs.</span>
			</Link>
			<Link
				key="signals"
				className="reactilyApiCard"
				to="/docs/api/signals/create-signal"
			>
				<strong>Signals</strong>
				<span>Browse signals APIs.</span>
			</Link>
			<Link
				key="state"
				className="reactilyApiCard"
				to="/docs/api/state/batch"
			>
				<strong>State & Stores</strong>
				<span>Browse state & stores APIs.</span>
			</Link>
			<Link
				key="theme-style"
				className="reactilyApiCard"
				to="/docs/api/theme-style/apply-style"
			>
				<strong>Theme & Style</strong>
				<span>Browse theme & style APIs.</span>
			</Link>
			<Link
				key="typed-creators"
				className="reactilyApiCard"
				to="/docs/api/typed-creators/create-billboard-gui"
			>
				<strong>Typed Creators</strong>
				<span>Browse typed creators APIs.</span>
			</Link>
			<Link
				key="virtual-tree"
				className="reactilyApiCard"
				to="/docs/api/virtual-tree/create-component"
			>
				<strong>Virtual Tree & Roots</strong>
				<span>Browse virtual tree & roots APIs.</span>
			</Link>
			<Link
				key="virtualization"
				className="reactilyApiCard"
				to="/docs/api/virtualization/create-variable-virtual-list"
			>
				<strong>Virtualization</strong>
				<span>Browse virtualization APIs.</span>
			</Link>
					</div>
				</div>
			</main>
		</Layout>
	);
}
