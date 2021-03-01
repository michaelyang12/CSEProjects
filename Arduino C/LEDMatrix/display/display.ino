/* display
 *  
 *  CSE 132 - Assignment 7
 *  
 *  Fill this out so we know whose assignment this is.
 *  
 *  Name:
 *  WUSTL Key:
 *  
 *  Name:
 *  WUSTL Key:
 *  
 */

#include "font.h"

void setup () 
{
  // insert code here as needed
  Serial.begin(9600);
  char c = 0x41;
  Serial.println(font_5x7[c][0],BIN);
  Serial.println(font_5x7[c][1],BIN);
  Serial.println(font_5x7[c][2],BIN);
  Serial.println(font_5x7[c][3],BIN);
  Serial.println(font_5x7[c][4],BIN);
}

void loop ()
{
  // insert code here as needed





}
