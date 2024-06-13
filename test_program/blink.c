/*
    Pico Build Action - Simple blink test program.
    Copyright 2024 Samyar Sadat Akhavi
    Written by Samyar Sadat Akhavi, 2024.
 
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
  
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https: www.gnu.org/licenses/>.
*/


// ---- Libraries & Modules ----
#include <stdio.h>
#include "pico/stdlib.h"


// ---- Definitions ----
#define ONBOARD_LED  25


// ---- Main Function ----
int main() 
{
    gpio_init(ONBOARD_LED);
    gpio_set_dir(ONBOARD_LED, true);

    while (true) 
    {
        gpio_put(ONBOARD_LED, 1);
        sleep_ms(1000);
        gpio_put(ONBOARD_LED, 0);
        sleep_ms(1000);
    }
}