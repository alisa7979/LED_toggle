---

# 🔴 LED Shift with Switch-Based Delay (ARM Assembly + C)

This project demonstrates **LED control** on an embedded system using **ARM Assembly** and **C**. The system cycles an LED across 8 positions (LD0 to LD7), with the **delay speed controlled by hardware switches (SW0–SW7)**.

Developed for the *Computer Systems Design* course at Korea University.

---

## 📂 Files

| Filename             | Description                                                                                                                   |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `led_init.S`         | ARM Assembly code that shifts a single LED from LD0 to LD7 in a loop. Calls the C delay function after each LED update.       |
| `led_switch_delay.c` | C function `csd_main()` that determines the delay time based on the highest-priority switch that is on. Linked from Assembly. |

---

## 🔧 Hardware Assumptions

* **Target Platform:** Xilinx ZedBoard (ARM Cortex-A9)
* **LED Address:** `0x41200000` (memory-mapped)
* **Switch Address:** `0x41210000` (memory-mapped)
* **LEDs:** LD0–LD7 are controlled via writing values to `csd_LED_ADDR`
* **Switches:** SW0–SW7 are read to adjust delay speed (SW7 = fastest, SW0 = slowest)

---

## 🧠 How It Works

### `led_init.S`

* Starts with LD0 lit (`r1 = 0x1`)
* Repeatedly:

  1. Writes the current LED value to `csd_LED_ADDR`
  2. Calls `csd_main()` (C delay function)
  3. Shifts the LED bit left (LD0 → LD1 → ... → LD7 → LD0)

### `led_switch_delay.c`

* Reads switches using pointer to `SW_ADDR`
* Scans switches from **SW7 to SW0** (priority)
* Sets a delay value according to which switch is first detected:

  * `delay = (8 - i) * 1200` (for switch `i`)
* Executes a simple loop to consume time (not cycle-accurate)

---

## ▶️ Build & Run Instructions

1. **Set up your cross-compilation toolchain** for ARM (e.g. `arm-none-eabi-gcc`)

2. **Compile C and Assembly:**

   ```bash
   arm-none-eabi-gcc -c led_switch_delay.c -o led_switch_delay.o
   arm-none-eabi-as led_init.S -o led_init.o
   arm-none-eabi-ld led_init.o led_switch_delay.o -Ttext=0x00000000 -o led_demo.elf
   ```

3. **Convert to binary or .bin/.elf for your loader:**

   ```bash
   arm-none-eabi-objcopy -O binary led_demo.elf led_demo.bin
   ```

4. **Load to ZedBoard (e.g. via UART, JTAG, or SD card bootloader)**

---

## 📊 LED Pattern Example

If LD2 is lit (0x4) and SW4 is high:

* Delay is `1200 * (8 - 4) = 4800` units
* LD2 → LD3 → LD4... LED continues to cycle with that delay until another switch is toggled.

---
