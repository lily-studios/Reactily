import { Link } from "react-router";

export function Brand() {
  return (
    <Link className="brand" to="/" aria-label="Reactily home">
      <span className="brandMark" aria-hidden="true">R</span>
      <span className="brandName">Reactily</span>
    </Link>
  );
}
