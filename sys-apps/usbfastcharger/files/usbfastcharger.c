/*
 * Copyright (C) 2015 Marek Rychly and authors of ipad_charge
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * The source code is based on
 * https://github.com/mkorenkov/ipad_charge/blob/master/ipad_charge.c
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libusb-1.0/libusb.h>

#define DEBUG
#define CTRL_OUT (LIBUSB_REQUEST_TYPE_VENDOR | LIBUSB_ENDPOINT_OUT)

void help(char *progname) {
	fprintf(stderr, "\nUsage: %s <enable|disable> -s bus:devnum\n", progname);
	fprintf(stderr, "Enable or disable fast charging on specified bus device numbers (in decimal).\n");
	fprintf(stderr, "\nUsage: %s <enable|disable> -d vendor:product\n", progname);
	fprintf(stderr, "Enable or disable fast charging of devices with the specified vendor and product ID numbers (in hexadecimal).\n");
}

int main(int argc, char *argv[]) {

	// help

	char *progname = argv[0];

	if ((argc < 4) || ((argc == 1) && (strcmp(argv[1], "--help") == 0))) {
		help(progname);
		return -1;
	}

	// enable/disable fast charging

	bool enable;

	if (strcmp(argv[1], "enable") == 0) {
		enable = 1;
	} else if (strcmp(argv[1], "disable") == 0) {
		enable = 0;
	} else {
		help(progname);
		return -2;
	}

	// device by bus number or product number

	bool busnumber;

	if (strcmp(argv[2], "-s") == 0) {
		busnumber = 1;
	} else if (strcmp(argv[2], "-d") == 0) {
		busnumber = 0;
	} else {
		help(progname);
		return -3;
	}

	// bus/product numbers

	int num1, num2;

	char *numstr1 = argv[3];
	char *numstr2 = strchr(numstr1, ':');
	if (numstr2 == NULL) {
		help(progname);
		return -4;
	}
	memset(numstr2, '\0', 1);
	numstr2++;

	num1 = atoi(numstr1);
	num2 = atoi(numstr2);

#ifdef DEBUG
	fprintf(stderr, "debug: enable = %d, busnumber = %d, num1 = %d, num2 = %d\n", enable, busnumber, num1, num2);
#endif

	// libusb

	int result = 0;

	if (libusb_init(NULL) < 0) {
		fprintf(stderr, "%s: failed to initialise libusb\n", progname);
		return -5;
	}

	libusb_device **devs;
	if (libusb_get_device_list(NULL, &devs) < 0) {
		fprintf(stderr, "%s: unable to enumerate USB devices\n", progname);
		result = -6;
		goto out_exit;
	}

	libusb_device *dev;
	int i;
	for (i = 0; (dev = devs[i++]) != NULL; i++) {
		if (busnumber) {
			if ((libusb_get_bus_number(dev) == num1) && (libusb_get_device_address(dev) == num2)) {
				break;
			}
		} else {
			struct libusb_device_descriptor desc;
			int retval;
			if ((retval = libusb_get_device_descriptor(dev, &desc)) < 0) {
				fprintf(stderr, "%s: failed to get device descriptor (error %d): %s\n", progname, retval, libusb_strerror(retval));
				continue;
			}
			if ((desc.idVendor == num1) && (desc.idProduct == num2)) {
				break;
			}
		}
	}

	if (dev == NULL) {
		fprintf(stderr, "%s: no such device or an error occured\n", progname);
		result = -7;
	} else {
		struct libusb_device_handle *dev_handle;
		int ret;

		if ((ret = libusb_open(dev, &dev_handle)) < 0) {
			fprintf(stderr, "%s: unable to open device (error %d): %s\n", progname, ret, libusb_strerror(ret));
			result = -8;
		} else {

			int active;

			if ((active = libusb_kernel_driver_active(dev_handle, 0)) < 0) {
				fprintf(stderr, "%s: unable to check kernel driver status (error %d): %s\n", progname, ret, libusb_strerror(ret));
				result = -9;
				goto out_close;
			}

			if (active) {
				if ((ret = libusb_detach_kernel_driver(dev_handle, 0)) < 0) {
					fprintf(stderr, "%s: unable to detach kernel driver (error %d): %s\n", progname, ret, libusb_strerror(ret));
					result = -9;
					goto out_close;
				}
			}

			if ((ret = libusb_claim_interface(dev_handle, 0)) < 0) {
				fprintf(stderr, "%s: unable to claim interface (error %d): %s\n", progname, ret, libusb_strerror(ret));
				result = -10;
				goto out_attach;
			}

			if ((ret = libusb_control_transfer(dev_handle, CTRL_OUT, 0x40, 500, enable ? 1600 : 0, NULL, 0, 2000)) < 0) {
				fprintf(stderr, "%s: unable to send command (error %d): %s\n", progname, ret, libusb_strerror(ret));
				result = -11;
				goto out_release;
			}

out_release:
			libusb_release_interface(dev_handle, 0);
out_attach:
			if (active) {
				libusb_attach_kernel_driver(dev_handle, 0);
			}
out_close:
			libusb_close(dev_handle);

		}
	}

	libusb_free_device_list(devs, 1);
out_exit:
	libusb_exit(NULL);

	return result;
}
