#define SW_ADDR  ((volatile unsigned int *) 0x41210000)

int csd_main() {
    unsigned int switches = *SW_ADDR;
    int delay = 12000;  // default

    for (int i = 7; i >= 0; i--) {
        if ((switches >> i) & 1) {   // 0b1000 0000 -> 0b0000 0001
            delay = (8 - i) * 1200;  // 100 for SW7, 200 for SW6, ..., 800 for SW0
            break;
        }
    }

    // simple delay loop (not accurate, just approximate)
    volatile int count = delay * 12000;
    while (count--);

    return 0;
}
