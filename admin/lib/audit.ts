import { createAdminClient } from "./supabase/admin";

/** Records an admin action in admin_audit_log. Best-effort (never throws). */
export async function logAction(
  actorEmail: string | undefined | null,
  action: string,
  entity?: string,
  entityId?: string,
  detail?: string
) {
  try {
    const db = createAdminClient();
    await db.from("admin_audit_log").insert({
      actor_email: actorEmail || "unknown",
      action,
      entity: entity ?? null,
      entity_id: entityId ?? null,
      detail: detail ?? null,
    });
  } catch {
    // auditing must never block the actual operation
  }
}
