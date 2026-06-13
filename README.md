# 🕐 Assembly Clock

A 12-hour countdown clock written in x86 Assembly (MASM/TASM), running entirely on DOS interrupts. The program prompts the user to enter a starting time, ticks forward second by second displaying each tick in `HH:MM:SS` format, and automatically stops once it completes a full 12-hour cycle back to the starting time.

---

## What the Program Does

1. Prompts the user to enter a starting **second**, **minute**, and **hour** (each as a single digit, 0–9).
2. Displays the current time on screen in `HH:MM:SS` format, updating every tick.
3. Increments seconds → minutes → hours with proper carry logic (e.g. 59 seconds rolls over to the next minute).
4. Resets automatically from `12:00:00` back to `00:00:00` (12-hour format).
5. Stops and prints a message when the clock loops back to the user's starting time.

---

## Assembler

This program uses **MASM** (Microsoft Macro Assembler) directives (`.MODEL SMALL`, `.STACK`, `.DATA`, `.CODE`) and **DOS INT 21h** system calls.

It is compatible with:

- **MASM** (Microsoft Macro Assembler)
- **TASM** (Borland Turbo Assembler)
- **emu8086** (emulator — recommended for beginners)
- **DOSBox** with MASM/TASM installed

---

## How to Assemble & Run

### Option 1 — Using emu8086 (easiest)

1. Download and install [emu8086](https://emu8086-microprocessor-emulator.en.softonic.com/).
2. Open `count.asm` in the emu8086 editor.
3. Click **Compile** then **Run**.

---

### Option 2 — Using MASM + DOSBox

**Step 1 — Set up DOSBox**

Download [DOSBox](https://www.dosbox.com/) and mount a folder containing `MASM.EXE`, `LINK.EXE`, and `count.asm`:

```
mount C C:\masm_folder
C:
```

**Step 2 — Assemble**

```
MASM count.asm;
```

**Step 3 — Link**

```
LINK count.obj;
```

**Step 4 — Run**

```
count.exe
```

---

### Option 3 — Using TASM + DOSBox

```
TASM count.asm
TLINK count.obj
count.exe
```

---

## Sample Output

```
Enter the second (0-9): 5
Enter the minute (0-9): 3
Enter the hour (0-9): 2

02:03:05
02:03:06
02:03:07
...
02:03:04

Clock has stopped at your time.
```

> The clock ticks through all 12 hours from your start time and halts when it returns to it.

---

## Code Structure

| Procedure | Description |
|---|---|
| `MAIN` | Entry point — handles input and the main clock loop |
| `GET_DIGIT_INPUT` | Reads a single digit (0–9) from the user via DOS INT 01h |
| `DISPLAY_CURRENT_TIME` | Prints time in `HH:MM:SS` format using DOS INT 02h |
| `UPDATE_TIME` | Increments seconds, propagates carry to minutes and hours |
| `CHECK_STOP_CONDITION` | Compares current time against start time; returns 1 if matched |
| `SHORT_DELAY` | NOP-based delay loop to slow down the display |

---

## Key Concepts Demonstrated

- DOS interrupt calls (`INT 21h` — functions 01h, 02h, 09h, 4Ch)
- Register usage (`AX`, `DX`, `CX`, `AL`, `DL`)
- Memory-mapped variables for storing time digits
- Carry propagation logic across seconds, minutes, and hours
- Procedure definition and `CALL`/`RET` mechanics
- ASCII ↔ integer conversion (`SUB AL, '0'` and `ADD DL, '0'`)

---

## Limitations & Notes

- Accepts only a **single digit (0–9)** per field — e.g. entering hour `2` means `02:xx:xx`.
- The clock does **not** run in real time — the delay loop (`SHORT_DELAY`) is a simple NOP loop and does not map to actual wall-clock seconds.
- The clock uses a **12-hour format** and wraps from `11:59:59` → `00:00:00`.
