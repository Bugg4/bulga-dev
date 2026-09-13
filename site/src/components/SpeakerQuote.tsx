import type { ReactNode } from "react";

export type Speaker = "Y" | "G";
export type QuoteVariant = "yellow" | "green";

interface SpeakerQuoteProps {
  children: ReactNode;
  speaker?: Speaker;
  variant?: QuoteVariant;
}

const speakerToVariant: Record<Speaker, QuoteVariant> = {
  Y: "yellow",
  G: "green",
};

/** Inline yellow quote, matching the legacy Typst `#quote[...]` rendering. */
export function Quote({ children }: { children: ReactNode }) {
  return (
    <span className="quote">
      <em>&ldquo;{children}&rdquo;</em>
    </span>
  );
}

/**
 * Speaker-attributed inline quote from post 003.
 * `speaker="Y"` renders yellow, `speaker="G"` renders green.
 * Rendered statically; no client JavaScript is shipped.
 */
export default function SpeakerQuote({
  children,
  speaker,
  variant,
}: SpeakerQuoteProps) {
  const resolved: QuoteVariant =
    variant ?? (speaker ? speakerToVariant[speaker] : "yellow");
  return (
    <span className={`quote quote-${resolved}`}>
      <em>&ldquo;{children}&rdquo;</em>
    </span>
  );
}
