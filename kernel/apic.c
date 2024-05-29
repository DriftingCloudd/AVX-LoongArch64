#include "include/apic.h"


void
apic_init(void)
{
  *(volatile uint64*)(LS7A_INT_MASK_REG) = ~((0x1UL << UART0_IRQ) | (0x1UL << KEYBOARD_IRQ) | (0x1UL << MOUSE_IRQ));

  *(volatile uint64*)(LS7A_INT_EDGE_REG) = ((0x1UL << UART0_IRQ) | (0x1UL << KEYBOARD_IRQ) | (0x1UL << MOUSE_IRQ));

  *(volatile unsigned char*)(LS7A_INT_HTMSI_VEC_REG + UART0_IRQ) = UART0_IRQ;
  *(volatile unsigned char*)(LS7A_INT_HTMSI_VEC_REG + KEYBOARD_IRQ) = KEYBOARD_IRQ;
  *(volatile unsigned char*)(LS7A_INT_HTMSI_VEC_REG + MOUSE_IRQ) = MOUSE_IRQ;

  *(volatile uint64*)(LS7A_INT_POL_REG) = 0x0UL;

}

// tell the apic we've served this IRQ.
void
apic_complete(uint64 irq)
{
  *(volatile uint64*)(LS7A_INT_CLEAR_REG) = (irq);
}