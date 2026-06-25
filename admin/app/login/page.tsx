"use client";

import { useActionState } from "react";
import { login } from "./actions";

export default function LoginPage() {
  const [state, formAction, pending] = useActionState(login, {});

  return (
    <div className="login-wrap">
      <div className="card login-card">
        <div className="brand">
          <span className="logo">M</span> MartoraX Admin
        </div>
        {state?.error && <div className="error">{state.error}</div>}
        <form action={formAction}>
          <div className="field">
            <label htmlFor="email">Email</label>
            <input id="email" name="email" type="email" autoComplete="email" required />
          </div>
          <div className="field">
            <label htmlFor="password">Password</label>
            <input id="password" name="password" type="password" autoComplete="current-password" required />
          </div>
          <button className="btn btn-primary" style={{ width: "100%", justifyContent: "center" }} disabled={pending}>
            {pending ? "Signing in…" : "Sign in"}
          </button>
        </form>
      </div>
    </div>
  );
}
