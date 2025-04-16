#include <stdio.h>

#include <stdio.h>
#include <stdint.h>
#include <string.h>

extern uint8_t dinoxor(uint8_t x0, uint8_t x1);

void printBits(unsigned int num)
{
    printf("0b");
    for(int bit=0;bit<(sizeof(uint8_t) * 8); bit++)
    {
        printf("%i", num & 0x01);
        num = num >> 1;
    }
    printf("\n");
}

int main() {
    uint8_t a = 0b01010101;
    uint8_t b = 0b10101010;

    uint8_t ret = dinoxor(a, b);

    printBits(ret);

    return 0;
}
