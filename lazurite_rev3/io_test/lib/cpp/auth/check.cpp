#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../ftdi/ftd2xx.h"

#define SUCCEEDED			0
#define	ERR_ARGC			1
#define	ERR_LIST_DEVICE		2
#define	ERR_NO_DEVICE		3
#define	ERR_CBUS_BITBANG	4
#define	ERR_EE_PROGRAM		5

// memory for storing parameters
char Manufacturer[32];
char ManufacturerId[64];
char Description[64];
char SerialNumber[16];

int main(void)
{
	FT_STATUS ftStatus;
	FT_HANDLE hFt;
	static FT_PROGRAM_DATA Data;
	DWORD numDevs = 0;
	DWORD testDev;
	int ret=SUCCEEDED;


	// get number of devices
	ftStatus = FT_ListDevices(&numDevs,NULL,FT_LIST_NUMBER_ONLY);
	if(ftStatus != FT_OK) {
		ret = -ERR_LIST_DEVICE;
		return ret;
	} 

	// connect memory 
	Data.Manufacturer = Manufacturer; /* E.g "FTDI" */
	Data.ManufacturerId = ManufacturerId; /* E.g. "FT" */
	Data.Description = Description; /* E.g. "USB HS Serial Converter" */
	Data.SerialNumber = SerialNumber; /* E.g. "FT000001" if fixed, or NULL */

	// get Manufacture and description
	for (testDev = 0;testDev < numDevs; testDev++) {
		ftStatus = FT_Open(testDev, &hFt);
		if(ftStatus != FT_OK) {
			continue;
		}
		Data.Signature1 = 0x00000000;
		Data.Signature2 = 0xffffffff;
		ftStatus = FT_EE_Read(hFt,&Data);
		if(ftStatus != FT_OK) {
			FT_Close(hFt);
			continue;
		}

		//if((strncmp(Manufacturer,"FTDI",32) == 0) &&
			//(strncmp(Description,"FT232R USB UART",64)==0))
		printf("Signature1=%08x\n",Data.Signature1);
		printf("Signature2=%08x\n",Data.Signature2);
		printf("Version=%08x\n",Data.Version);
		printf("VendorId=%04x\n",Data.VendorId);
		printf("ProductId=%04x\n",Data.ProductId);
		printf("*Manufacturer=%s\n",Data.Manufacturer);
		printf("*ManufacturerId=\n");
		for(int a=0;a<4;a++)
		{
			for(int b=0;b<16;b++)
			{
				printf("%2x ",ManufacturerId[a*16+b]);
			}
			printf("\n");
		}
		printf("*Description=%s\n",Data.Description);
		printf("*SerialNumber=%s\n",Data.SerialNumber);
		printf("MaxPower=%04x\n",Data.MaxPower);
		printf("PnP=%04x\n",Data.PnP);
		printf("SelfPowered=%04x\n",Data.SelfPowered);
		printf("RemoteWakeup=%04x\n",Data.RemoteWakeup);
		printf("Rev4=%04x\n",Data.Rev4);
		printf("IsoIn=%04x\n",Data.IsoIn);
		printf("IsoOut=%04x\n",Data.IsoOut);
		printf("PullDownEnable=%04x\n",Data.PullDownEnable);
		printf("SerNumEnable=%04x\n",Data.SerNumEnable);
		printf("USBVersionEnable=%04x\n",Data.USBVersionEnable);
		printf("USBVersion=%04x\n",Data.USBVersion);
		printf("Rev5=%04x\n",Data.Rev5);
		printf("IsoInA=%04x\n",Data.IsoInA);
		printf("IsoInB=%04x\n",Data.IsoInB);
		printf("IsoOutA=%04x\n",Data.IsoOutA);
		printf("IsoOutB=%04x\n",Data.IsoOutB);
		printf("PullDownEnable5=%04x\n",Data.PullDownEnable5);
		printf("SerNumEnable5=%04x\n",Data.SerNumEnable5);
		printf("USBVersionEnable5=%04x\n",Data.USBVersionEnable5);
		printf("USBVersion5=%04x\n",Data.USBVersion5);
		printf("AIsHighCurrent=%04x\n",Data.AIsHighCurrent);
		printf("BIsHighCurrent=%04x\n",Data.BIsHighCurrent);
		printf("IFAIsFifo=%04x\n",Data.IFAIsFifo);
		printf("IFAIsFifoTar=%04x\n",Data.IFAIsFifoTar);
		printf("IFAIsFastSer=%04x\n",Data.IFAIsFastSer);
		printf("AIsVCP=%04x\n",Data.AIsVCP);
		printf("IFBIsFifo=%04x\n",Data.IFBIsFifo);
		printf("IFBIsFifoTar=%04x\n",Data.IFBIsFifoTar);
		printf("IFBIsFastSer=%04x\n",Data.IFBIsFastSer);
		printf("BIsVCP=%04x\n",Data.BIsVCP);
		printf("UseExtOsc=%04x\n",Data.UseExtOsc);
		printf("HighDriveIOs=%04x\n",Data.HighDriveIOs);
		printf("EndpointSize=%04x\n",Data.EndpointSize);
		printf("PullDownEnableR=%04x\n",Data.PullDownEnableR);
		printf("SerNumEnableR=%04x\n",Data.SerNumEnableR);
		printf("InvertTXD=%04x\n",Data.InvertTXD);
		printf("InvertRXD=%04x\n",Data.InvertRXD);
		printf("InvertRTS=%04x\n",Data.InvertRTS);
		printf("InvertCTS=%04x\n",Data.InvertCTS);
		printf("InvertDTR=%04x\n",Data.InvertDTR);
		printf("InvertDSR=%04x\n",Data.InvertDSR);
		printf("InvertDCD=%04x\n",Data.InvertDCD);
		printf("InvertRI=%04x\n",Data.InvertRI);
		printf("Cbus0=%04x\n",Data.Cbus0);
		printf("Cbus1=%04x\n",Data.Cbus1);
		printf("Cbus2=%04x\n",Data.Cbus2);
		printf("Cbus3=%04x\n",Data.Cbus3);
		printf("Cbus4=%04x\n",Data.Cbus4);
		printf("RIsD2XX=%04x\n",Data.RIsD2XX);
	}
	 // error check
	FT_Close(hFt);
	//printf("%d\n",ret);
	return ret;
}

