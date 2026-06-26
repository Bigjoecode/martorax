"use client";

import {
  ResponsiveContainer,
  LineChart, Line,
  BarChart, Bar,
  PieChart, Pie, Cell,
  XAxis, YAxis, Tooltip, CartesianGrid,
} from "recharts";

const EMERALD = "#059669";
const AMBER = "#f59e0b";
const PIE = ["#059669", "#f59e0b", "#3b82f6", "#ef4444", "#22c55e", "#a855f7", "#94a3b8"];

const axis = { stroke: "#64748b", fontSize: 11 };
const tooltipStyle = {
  background: "#162032",
  border: "1px solid #24344a",
  borderRadius: 8,
  color: "#e8eef5",
  fontSize: 12,
};

function naira(n: number) {
  return "₦" + Number(n || 0).toLocaleString("en-NG", { maximumFractionDigits: 0 });
}

export function RevenueLine({ data }: { data: { label: string; value: number }[] }) {
  return (
    <ResponsiveContainer width="100%" height={240}>
      <LineChart data={data} margin={{ top: 8, right: 12, left: 0, bottom: 0 }}>
        <CartesianGrid stroke="#1e2d3d" vertical={false} />
        <XAxis dataKey="label" {...axis} />
        <YAxis {...axis} width={48} tickFormatter={(v) => (v >= 1000 ? `${v / 1000}k` : `${v}`)} />
        <Tooltip contentStyle={tooltipStyle} formatter={(v: number) => naira(v)} />
        <Line type="monotone" dataKey="value" stroke={EMERALD} strokeWidth={2} dot={false} />
      </LineChart>
    </ResponsiveContainer>
  );
}

export function OrdersBar({ data }: { data: { label: string; value: number }[] }) {
  return (
    <ResponsiveContainer width="100%" height={240}>
      <BarChart data={data} margin={{ top: 8, right: 12, left: 0, bottom: 0 }}>
        <CartesianGrid stroke="#1e2d3d" vertical={false} />
        <XAxis dataKey="label" {...axis} />
        <YAxis {...axis} width={36} allowDecimals={false} />
        <Tooltip contentStyle={tooltipStyle} />
        <Bar dataKey="value" fill={AMBER} radius={[4, 4, 0, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

export function CategoryPie({ data }: { data: { label: string; value: number }[] }) {
  if (data.length === 0) return <Empty />;
  return (
    <ResponsiveContainer width="100%" height={240}>
      <PieChart>
        <Pie data={data} dataKey="value" nameKey="label" cx="50%" cy="50%" outerRadius={90} label={(e: any) => e.label}>
          {data.map((_, i) => <Cell key={i} fill={PIE[i % PIE.length]} />)}
        </Pie>
        <Tooltip contentStyle={tooltipStyle} formatter={(v: number) => naira(v)} />
      </PieChart>
    </ResponsiveContainer>
  );
}

export function TopVendorsBar({ data }: { data: { label: string; value: number }[] }) {
  if (data.length === 0) return <Empty />;
  return (
    <ResponsiveContainer width="100%" height={Math.max(240, data.length * 34)}>
      <BarChart data={data} layout="vertical" margin={{ top: 8, right: 16, left: 8, bottom: 0 }}>
        <CartesianGrid stroke="#1e2d3d" horizontal={false} />
        <XAxis type="number" {...axis} tickFormatter={(v) => (v >= 1000 ? `${v / 1000}k` : `${v}`)} />
        <YAxis type="category" dataKey="label" {...axis} width={120} />
        <Tooltip contentStyle={tooltipStyle} formatter={(v: number) => naira(v)} />
        <Bar dataKey="value" fill={EMERALD} radius={[0, 4, 4, 0]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

function Empty() {
  return (
    <div style={{ height: 240, display: "grid", placeItems: "center", color: "var(--muted)", fontSize: 13 }}>
      No data yet.
    </div>
  );
}
