// geiger
// CPM to uSv/h ratio: 153.8 CPM per uSv/h = 6.502 nSv/h per CPM
// = 56.996 uSv per year per CPM. 
// Background dose received by an average person per year, including medical
//  scans = 4000 uSv. (XKCD)
// 1 REM = 10000 uSv

#include <util/atomic.h>
#define ALARM_CPM 70
const int geiger_pin = 2;
const int meter_pin = 3;
const int count_led_pin = 13;
const int alarm_led_pin = 9;
const int n=20;
volatile int pos=0;
volatile long buf[n];
volatile int led=0;
volatile bool triggered=false;
const int maxcpm=100;
unsigned long printtimer=0;

void setup() {
  pinMode(meter_pin, OUTPUT);
  pinMode(count_led_pin, OUTPUT);
  pinMode(alarm_led_pin, OUTPUT);
  
  digitalWrite(alarm_led_pin, HIGH);
  // Ring buffer
  for (int i=0; i<n; i++) { buf[i] = -1; }

  Serial.begin(115200);
  pinMode(geiger_pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(geiger_pin), isrcount, FALLING);
}

void loop() {
    long avg, cpm;
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {   
        if (buf[pos] != -1 && triggered) {
            // ms between pulses
            avg = (buf[pos>0 ? pos-1 : n-1] - buf[pos]) / (n -1);
            cpm = min(maxcpm, 60000 / avg);
            analogWrite(meter_pin, map(cpm,0,maxcpm,0,255));
            triggered = false;
        }
    }
    if (cpm > ALARM_CPM) { digitalWrite(alarm_led_pin, HIGH); } 
    else { digitalWrite(alarm_led_pin, LOW); }
    if ((millis()- printtimer)  > 10000) {
//            printbuffer();
            if (buf[pos] != -1) { 
//                Serial.print(avg);
//                Serial.print("\t");
                Serial.print(cpm);
            }
            Serial.println();
            printtimer = millis();
    }
}

void isrcount() {
  buf[pos] = millis();
  pos++;
  if (pos > n-1) { pos = 0; }
  led = !led;
  digitalWrite(count_led_pin, led);
  triggered = true;
}

void printbuffer() { 
    Serial.println(' ');
    for (int i=0; i<n; i++) {
        Serial.print(i);
        Serial.print("\t");
        Serial.print(buf[i]);
        if (i == pos) { 
            Serial.println("\t<----");
        }
        else { 
           Serial.println();
        }
    }
    //delay(1000);
}

