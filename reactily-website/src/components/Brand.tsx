import { Link } from "react-router";
import { useVersionedDocs } from "../lib/versioned-docs";

export function Brand() {
  const { path } = useVersionedDocs();
  return (
    <Link className="brand" to={path("/")} aria-label="Reactily home">
      <img
        className="brandMark"
        src={`${import.meta.env.BASE_URL}reactily-icon.svg`}
        alt=""
        aria-hidden="true"
        width={32}
        height={32}
      />
      <span className="brandName">Reactily</span>
    </Link>
  );
}
