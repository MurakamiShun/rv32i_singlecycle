#include <stdbool.h>

extern unsigned char* _input;
extern unsigned char* _output;

__attribute__((naked))
__attribute__((section(".text.entry")))
void entry(void){
    while(true){
        for(int i = 0; i < 32; ++i){
            *_output = i + '0';
        }
    }
}