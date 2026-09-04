import type { ButtonHTMLAttributes, HTMLAttributes, PropsWithChildren } from "react";

export function joinClasses(...parts: Array<string | false | null | undefined>): string {
  return parts.filter(Boolean).join(" ");
}

export function Card({ className, ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={joinClasses("prolabos-card", className)} {...props} />;
}

export function SectionTitle({ className, ...props }: HTMLAttributes<HTMLHeadingElement>) {
  return <h2 className={joinClasses("prolabos-section-title", className)} {...props} />;
}

export function Eyebrow({ className, ...props }: HTMLAttributes<HTMLParagraphElement>) {
  return <p className={joinClasses("prolabos-eyebrow", className)} {...props} />;
}

export function Button({
  children,
  className,
  variant = "primary",
  ...props
}: PropsWithChildren<ButtonHTMLAttributes<HTMLButtonElement> & { variant?: "primary" | "secondary" | "ghost" }>) {
  return (
    <button
      className={joinClasses("prolabos-button", `prolabos-button-${variant}`, className)}
      {...props}
    >
      {children}
    </button>
  );
}

export function StatusPill({
  children,
  className,
  tone = "neutral",
  ...props
}: PropsWithChildren<HTMLAttributes<HTMLSpanElement> & { tone?: "neutral" | "success" | "warning" }>) {
  return (
    <span className={joinClasses("prolabos-pill", `prolabos-pill-${tone}`, className)} {...props}>
      {children}
    </span>
  );
}

export function AuthFormShell({
  title,
  subtitle,
  children,
  footer,
}: PropsWithChildren<{ title: string; subtitle?: string; footer?: React.ReactNode }>) {
  return (
    <div className="prolabos-auth-shell">
      <Card className="prolabos-auth-card">
        <Eyebrow>ProlabOS</Eyebrow>
        <SectionTitle className="mt-2">{title}</SectionTitle>
        {subtitle ? <p className="prolabos-auth-subtitle">{subtitle}</p> : null}
        <div className="prolabos-auth-body">{children}</div>
        {footer ? <div className="prolabos-auth-footer">{footer}</div> : null}
      </Card>
    </div>
  );
}
