# SQF syntax reference

Sources: [SQF Syntax](https://community.bistudio.com/wiki/SQF_Syntax),
[Order of Precedence](https://community.bistudio.com/wiki/Order_of_Precedence),
[Control Structures](https://community.bistudio.com/wiki/Control_Structures),
[Variables](https://community.bistudio.com/wiki/Variables).

## Statements, brackets, comments

- An expression is terminated by `;` (conventional) or `,`. Line returns mean nothing — three statements on one
  line behave identically to three lines.
- `()` override precedence or aid readability. `[]` build Arrays. `{}` enclose Code, and are used by control
  structures.
- Leading and trailing whitespace on a line is ignored; blank lines are ignored.
- `// line comment` and `/* block comment */`. A comment may appear anywhere except inside a string, including
  mid-expression: `1 + /* why */ 1`.
- Comments are stripped during **preprocessing**. Code built at runtime with `compile` on a string that was never
  preprocessed will not have comments removed — they become syntax errors.
- There is a `comment` unary command. It executes at runtime and costs time while doing nothing; it exists only
  for backward compatibility. Do not use it. Likewise, a bare string used as a comment is executed.

## Operator arities

**Nular** — no operands. Each access recomputes:

```sqf
_units = allUnits;                  // snapshot of 5 units
group player createUnit [...];      // a 6th unit now exists
count _units;                       // still 5
count allUnits;                     // 6
```

Because they are recomputed, some nular commands are expensive in a loop — cache them when the value is stable.

**Unary** — takes the operand to its right, and takes the *first* one it encounters. This is the source of the
most common parse error:

```sqf
_arr = [[1,2,3,4,5],[1,2,3,4],[1,2]];
count _arr select 2;      // (count _arr) select 2 -> 3 select 2 -> error
count (_arr select 2);    // 2
```

**Binary** — `a op b`, resolved by precedence, then left to right within a level.

## Precedence table

| Level | Type | Examples |
|---|---|---|
| 11 | nular commands, variables, values, bracketed expressions | `player`, `_x`, `5`, `()`, `[]`, `{}`, `""` |
| 10 | unary commands | `count a`, `+a`, `-a`, `!b`, `not b` |
| 9 | hash-select | `array # index` |
| 8 | power | `a ^ b` |
| 7 | multiplication, division, remainder, `atan2`, config `/` | `a * b`, `a / b`, `a % b`, `a mod b`, `a atan2 b` |
| 6 | addition and subtraction (numbers, arrays, strings), `min`, `max` | `a + b`, `arr1 - arr2`, `a min b` |
| 5 | `else` | |
| 4 | binary commands | `a setDir b`, switch `:` |
| 3 | comparisons, config `>>` | `==`, `!=`, `>`, `<`, `>=`, `<=`, `config >> name` |
| 2 | logical and | `&&`, `and` |
| 1 | logical or | `\|\|`, `or` |

Worked example — the wiki's own:

```sqf
_arr select 0 select 1 - 1 select 15 / 3 - 5 select 0 select 10 * 10 + 4 * 0 - 100
// resolves as
((((_arr select 0) select (1 - 1)) select ((15 / 3) - 5)) select 0) select (((10 * 10) + (4 * 0)) - 100)
```

Note `sleep 10 + random 20` parses as `(sleep 10) + random 20` — the sleep is 10 seconds, not 10–30. Write
`sleep (10 + random 20)`.

`else` deserves a mention: it is an operator that packs the code on its left and right into a two-element array
and hands it to `then`. `if (c) then [{a}, {b}]` is the underlying form; `if (c) then {a} else {b}` is preferred
for readability and is cheaper than the array form.

## Booleans and conditions

`!` / `not`, `&&` / `and`, `||` / `or`. Control structures implicitly compare against `true`, so write
`if (_cond)` and `if (!_cond)` — never `if (_cond == true)`.

## Control structures in full

### if

```sqf
if (_temperature < 0) then { hint "Snow!"; };
if (_c) then { ... } else { ... };
if (_c) then [{ ... }, { ... }];          // array form, CPU-heavier
private _living = if (alive player) then { true } else { false };
```

### switch

```sqf
switch (_color) do {
    case "blue": { hint "nice"; };
    case "red":  { hint "aggressive?"; };
    default { hint "unknown"; };          // NO colon after default
};

private _marker = switch (side player) do {
    case west: { "ColorGreen" };
    case east: { "ColorRed" };
};

switch (true) do {                        // idiomatic if/else-ladder replacement
    case (_dmg >= 0.9): { hint "very damaged"; };
    case (_dmg >= 0.5): { hint "quite damaged"; };
    default { hint "fine"; };
};
```

### Loops

```sqf
while { _counter < 10 } do { _counter = _counter + 1; };   // condition in braces

for [{ _i = 0 }, { _i < 10 }, { _i = _i + 1 }] do { ... };  // init / condition / step
for "_i" from 0 to 9 do { ... };
for "_i" from 0 to 9 step 2 do { ... };                     // 5 iterations
for "_i" from 10 to 0 step -1 do { ... };                   // descending needs a negative step

{ _x setDamage 1; } forEach _array;                         // _x, _forEachIndex
```

- `while` tests before each pass, so it may run zero times. In an **unscheduled** context it is hard-capped at
  10,000 iterations.
- In `for "_i" from A to B do`, B must exceed A unless a negative `step` is supplied.
- Every `forEach` iteration completes within one frame — a large array with a heavy body will hitch.

### Return values

Every control structure returns the last expression evaluated inside it. That is what makes the conditional
assignment forms above work.

## Variables

### Initialisation and deletion

```sqf
myVariable = 0;          // global
private _local = 0;      // local
HugeVariable = nil;      // free a large global
```

Since Arma 2, reading an undefined variable raises `Undefined variable in expression`. Locals are freed
automatically when their scope ends.

### Scope

- **Global** — visible to every script on the machine that defined it. Editor-assigned unit names are globals.
  A global's value can differ between machines; see `references/multiplayer.md`.
- **Local** (`_`-prefixed) — visible only in the script, function or control structure that declared it. A local
  cannot be broadcast; assign it to a global first.

```sqf
private _myVariable = 0;
if (_condition) then {
    _myVariable = 1;
    private _myVariable = 2;      // shadows — a NEW variable inside this block
    _myVariable = 3;              // touches the shadow, not the outer one
} else {
    _myVariable = 4;
    private _anotherVariable = 10;
};
hint str _myVariable;             // 1 if _condition, else 4 — never 3
// _anotherVariable does not exist here

0 call { hint str _myVariable; };        // works — call shares the scope
[_myVariable] spawn { hint str _myVariable; };   // ERROR — spawn starts a new script with a new scope
```

Declaration forms, by engine version: `private _x = 0;` (Arma 3 ≥ 1.54), `local _x = 0;` (Arma 2 → A3 1.54),
`private "_x";` (older), `private ["_a", "_b"];` (multiple at once).

### Types

Variables are not strongly typed and change type on assignment. Core types: `Array`, `Boolean`, `Code`, `Config`,
`Control`, `Display`, `Group`, `HashMap`, `Location`, `Namespace`, `Number`, `Object`, `Script Handle`, `Side`,
`String`, `Structured Text`, `Task`, `Nothing`, `Anything`. Inspect with `typeName`, compare with `isEqualType`.

Special arrays worth knowing: `Position` (`[x, y]` or `[x, y, z]`; note ASL vs AGL are **not** interchangeable),
`Color`, `Date`, `Vector3D`, `Unit Loadout Array`, `Waypoint`.

### Arrays are references

```sqf
private _a = [1,2,3];
private _b = _a;     // alias — mutating _b mutates _a
private _c = +_a;    // deep copy
```

Useful operations: `select` / `#`, `select { condition }` (filter), `apply { expr }` (map), `findIf`, `pushBack`,
`pushBackUnique`, `deleteAt`, `set`, `append`, `count`, `find` (`-1` when absent), `in`, `{ cond } count _arr`.

### Storing code safely

```sqf
TAG_fnc_thing = compileFinal preprocessFileLineNumbers "functionFile.sqf";
```

A global holding code that is not `compileFinal` can be overwritten remotely via `publicVariable` — a real
multiplayer security hole. Run the definition locally on every machine rather than `publicVariable`-ing the
compiled code, which saturates the network.
