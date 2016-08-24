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

int main(int argc, char* argv[])
{
	FT_STATUS ftStatus;
	FT_HANDLE hFt;
	static FT_PROGRAM_DATA Data;
	DWORD numDevs = 0;
	DWORD testDev;
	int ret=SUCCEEDED;


	// check number of args
	if(argc < 2)
	{
		ret = -ERR_ARGC;
		return ret;
	}
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
		{
			strncpy(Manufacturer,argv[1],32);
			strncpy(Description,argv[2],64);
			strncpy(ManufacturerId,"A1",64);
			Data.Cbus0=10;
			Data.Cbus1=10;
			Data.Cbus2=0;
			Data.Cbus3=10;
			ftStatus = FT_EE_Program(hFt,&Data);
			if(ftStatus != FT_OK){
				printf("Fail FT_EE_Program=%d",ftStatus);
				FT_Close(hFt);
				ret |= -ERR_EE_PROGRAM;
				continue;
			} else {
				printf("success to write\n");
				break;
			}
		}
	}
	if (testDev >= numDevs) {
		ret = -ERR_NO_DEVICE;
	}
	 // error check
	FT_Close(hFt);
	//printf("%d\n",ret);
	return ret;
}

