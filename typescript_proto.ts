// -------------------------------------------------------------------------------------------------
// Prototypical Typescript
//
// How to compile / run this file
//
//   npx tsc --noEmit --strict typescript_proto.ts  // Type-check only; no output files
//
//   npx tsx typescript_proto.ts      // Run directly without a separate compile step; newer, uses esbuild, no type-check, much faster
//   npx ts-node typescript_proto.ts  // Run directly without a separate compile step; older, uses tsc, type-checks, slower
//
// Compile to JavaScript, then run with node:
//
//   npx tsc typescript_proto.ts
//   node typescript_proto.js


// -------------------------------------------------------------------------------------------------
// types

// An object type alias showcasing common per-field modifiers and shapes
// `?` marks a field as optional, meaning it may be omitted or `undefined`
type MyType = {
    secret: string;                     // required
    nowSeconds?: number;                // may be omitted or undefined; null is NOT allowed
    maxAgeSeconds?: number | null;      // may be omitted, undefined, or null
    readonly id: string;                // readonly: cannot be reassigned after creation
    tags: readonly string[];            // readonly array: cannot be mutated (no push, etc.)
    role: "admin" | "user";             // inline union of string literals
    metadata: Record<string, string>;   // built-in utility type: string-keyed map
    onChange?: (next: string) => void;  // optional function-typed field
    enabled: boolean;                   // primitive boolean
    createdAt: Date;                    // built-in object type from the standard lib
    score: bigint;                      // primitive bigint, for large integers
    kind: symbol;                       // primitive symbol: every Symbol() call yields a unique value, mainly used as collision-free object keys
    notes: string | null;               // required but nullable; cannot be undefined
    coords: [number, number];           // fixed-length tuple (mutable)
    history: Array<{ at: number; action: string }>; // array of inline object type
    payload: unknown;                   // anything goes, must be narrowed before use

    // built-in generic containers and runtime objects
    extras: Map<string, number>;        // Map: keyed lookup, preserves insertion order
    seen: Set<string>;                  // Set: unique values
    ready: Promise<string>;             // Promise: a future value
    matcher: RegExp;                    // regular expression
    buffer: ArrayBuffer;                // raw fixed-length binary buffer
    bytes: Uint8Array;                  // typed array view over bytes (8-bit unsigned)

    // recursive / self-referential
    parent: MyType | null;              // self-reference for tree-like structures

    // utility types (transformations of other types)
    labels: Partial<Record<string, string>>;          // Partial<T>: all props optional
    mustHave: Required<{ a?: string; b?: string }>;   // Required<T> strips the ? from every property, so:  Required<{ a?: string; b?: string }>  becomes  { a: string; b: string }
    frozen: Readonly<{ version: number }>;            // Readonly<T>: all props readonly
    justRole: Pick<{ role: "admin" | "user"; other: string }, "role">;       // Pick<T, K>: keep only listed keys, i.e. retains "role"
    withoutSecret: Omit<{ secret: string; name: string; age: number }, "secret">; // Omit<T, K>: drop listed keys, i.e. drops "secret"
};

const myValue: MyType = {
    secret: "shhh",
    id: "abc-123",
    tags: ["alpha", "beta"],
    role: "admin",
    metadata: { region: "eu" },
    enabled: true,
    createdAt: new Date(),
    score: 9_007_199_254_740_993n,
    kind: Symbol("my-kind"),
    notes: null,
    coords: [12, 34],
    history: [{ at: 1700000000, action: "created" }],
    payload: { anything: "goes" },

    extras: new Map<string, number>([["a", 1]]),
    seen: new Set<string>(["x", "y"]),
    ready: Promise.resolve("done"),
    matcher: /^hello/,
    buffer: new ArrayBuffer(8),
    bytes: new Uint8Array([1, 2, 3]),

    parent: null,

    labels: { en: "hi" },
    mustHave: { a: "x", b: "y" },
    frozen: { version: 1 },
    justRole: { role: "admin" },
    withoutSecret: { name: "n", age: 1 },
};

// simple alias for a primitive type
type UserId = string;

// union: can be one of several specific string literals
type Status = "draft" | "published" | "archived";

// intersection: a value that satisfies both types at once
type AuditedOptions = MyType & { createdBy: UserId };

// readonly tuple: a fixed-length array with typed positions that cannot be mutated
type LabeledNumber = readonly [string, number];
const myLabeledNumber: LabeledNumber = ["answer", 42];


// -------------------------------------------------------------------------------------------------
// nullish coalescing (??)

// `??` falls back to the right side only when the left side is null or undefined
// `||` falls back on any falsy value (null, undefined, 0, false, "", NaN)

const maybeName: string | null = null;
const myName: string = maybeName ?? "anonymous";  // "anonymous"

const count: number | undefined = 0;
const safeCount: number = count ?? 10;   // 0
const wrongCount: number = count || 10;  // 10


// -------------------------------------------------------------------------------------------------
// functions

function myFunction(input: string): string {
    return `hello:${input}`;
}

const myResult: string = myFunction("Johnny");
