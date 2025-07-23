#define csd_LED_ADDR 0x41200000

.extern csd_main
.global main

main:
    mov r1, #1          // initial LED bit (LD0 -> 0b00000001)
loop:
    ldr r0, =csd_LED_ADDR
    str r1, [r0]        // turn on current LED

    bl csd_main         // call C code to do delay (based on switches)

    // shift LED left (LD0 → LD1 → ... → LD7 → LD0)
    mov r2, r1
    lsl r1, r1, #1      // shift left by 1 (0b0000 0001 -> 0b0000 0010)
    cmp r1, #0x100      // if past LD7 (0x100 = 0b0001 0000 0000)
    bne skip_reset
    mov r1, #1          // reset to LD0

skip_reset:
    b loop              // repeat forever

// LED0 = 0x1	LED4 = 0x10
// LED1 = 0x2	LED5 = 0x20
// LED2 = 0x4	LED6 = 0x40
// LED3 = 0x8	LED7 = 0x80
