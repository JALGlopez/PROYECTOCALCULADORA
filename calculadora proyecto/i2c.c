#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

static int fd = -1;

int i2c_init(int address) {
    fd = open("/dev/i2c-1", O_RDWR);
    if (fd < 0) return -1;
    if (ioctl(fd, I2C_SLAVE, address) < 0) return -1;
    return 0;
}

void i2c_write_byte(unsigned char data) {
    write(fd, &data, 1);
}
