#include <am.h>
#include <klib-macros.h>
#include "./../riscv.h"

#define UART_BASE 0x10000000

// UART16550 registers
#define UART_RBR    0x00  // Receiver Buffer Register (read, DLAB=0)
#define UART_THR    0x00  // Transmitter Holding Register (write, DLAB=0)
#define UART_DLL    0x00  // Divisor Latch Low (DLAB=1)
#define UART_DLM    (0x01)  // Divisor Latch High (DLAB=1)
#define UART_IER    (0x01)  // Interrupt Enable Register (DLAB=0)
#define UART_FCR    (0x02)  // FIFO Control Register
#define UART_LCR    (0x03)  // Line Control Register
#define UART_MCR    (0x04)  // Modem Control Register
#define UART_LSR    (0x05) // Line Status Register
#define UART_MSR    (0x06)  // Modem Status Register

// Line Control Register bits
#define LCR_DLAB    0x80  // Divisor Latch Access Bit
#define LCR_8BITS   0x03  // 8 data bits
#define LCR_NOPAR   0x00  // No parity
#define LCR_1STOP   0x00  // 1 stop bit

// FIFO Control Register bits
#define FCR_ENABLE  0x01  // Enable FIFO
#define FCR_CLR_RCVR 0x02 // Clear receiver FIFO
#define FCR_CLR_XMIT 0x04 // Clear transmitter FIFO

// Line Status Register bits
#define LSR_TX_EMPTY 0x20  // Transmitter Holding Register Empty
#define LSR_THRE     0x20  // Transmit Holding Register Empty

// UART clock frequency (typical for 16550)
#define UART_CLK 1843200  // 1.8432 MHz

extern char _heap_start;
int main(const char *args);

extern char _pmem_start;
#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

Area heap = RANGE(&_heap_start, PMEM_END);
static const char mainargs[MAINARGS_MAX_LEN] = TOSTRING(MAINARGS_PLACEHOLDER); // defined in CFLAGS

void putch(char ch) {
	while ((inb(UART_BASE + UART_LSR) & LSR_THRE) == 0) {
        asm volatile("nop"); 
    }
	outb(UART_BASE + UART_THR, ch);
}

void halt(int code) {
  asm volatile("mv a0, %0; ebreak" : :"r"(code));
  while (1);
}

void _uart_init();

void _trm_init() {
  _uart_init();
  int ret = main(mainargs);
  halt(ret);
}

void _uart_init() {
    short divisor;

    // Step 1: Disable interrupts (set IER to 0)
    outb(UART_BASE + UART_IER, 0x00);

    // Step 2: Enable DLAB to set divisor
    outb(UART_BASE + UART_LCR, LCR_DLAB);

    // Step 3: Set divisor for baud rate
    // Baud Rate = UART_CLK / (16 * divisor)

    divisor = 1;  // This gives 115200 baud with 1.8432MHz clock

    // Write low byte of divisor
    outb(UART_BASE + UART_DLL, divisor & 0xFF);
    // Write high byte of divisor
    outb(UART_BASE + UART_DLM, (divisor >> 8) & 0xFF);

    // Step 4: Set line control register
    // 8 data bits, 1 stop bit, no parity, clear DLAB
    outb(UART_BASE + UART_LCR, LCR_8BITS | LCR_NOPAR | LCR_1STOP);

    // Step 5: Enable and configure FIFO
    // Enable FIFO, clear both transmitter and receiver FIFOs
    outb(UART_BASE + UART_FCR, FCR_ENABLE | FCR_CLR_RCVR | FCR_CLR_XMIT);

    // Step 6: Set modem control register
    // In simulation, we can leave it as default or set DTR/RTS
    outb(UART_BASE + UART_MCR, 0x00);
}

