#!/usr/bin/env python3
import os
import fcntl
import spidev
import time

I2C_BUS        = 2        # /dev/i2c-2
I2C_ADDR       = 0x40     
SPI_BUS        = 0        # /dev/spidev0.0
SPI_CS         = 0
FRAME_ROWS     = 120
FRAME_ROW_SIZE = 160

I2C_SLAVE = 0x0703

# --- I2C funkcije ---
def i2c_open(bus, addr):
    fd = os.open(f"/dev/i2c-{bus}", os.O_RDWR)
    fcntl.ioctl(fd, I2C_SLAVE, addr)
    return fd

def i2c_write_reg(fd, reg, value):
    os.write(fd, bytes([reg, value]))

# --- SPI funkcije ---
def spi_open(bus, cs, speed=1000000, mode=0, bpw=16):
    spi = spidev.SpiDev()
    spi.open(bus, cs)
    spi.max_speed_hz = speed
    spi.mode = mode
    spi.bits_per_word = bpw
    return spi

def spi_read_frame_row(spi, size_bytes):
    dummy = [0x0000] * size_bytes               # 160x2B dummy podataka
    row = spi.xfer2(dummy)                      # SPI transfer
    frame_row = bytearray()
    for word in row:
        frame_row += word.to_bytes(2, 'big')
    return frame_row


if __name__ == "__main__":

    i2c_fd = i2c_open(I2C_BUS, I2C_ADDR)
    i2c_write_reg(i2c_fd, 0x00, 0x01)  # SW Reset
    time.sleep(3)
    i2c_write_reg(i2c_fd, 0xB1, 0x21)

    spi = spi_open(SPI_BUS, SPI_CS)

    # Napravi praznu datoteku
    with open("image.bin", "wb") as f:
        pass

    # Citanje i skladistenje frame-a po redovima
    with open("image.bin", "ab") as f:
        for _ in range(FRAME_ROWS):
            row_data = spi_read_frame_row(spi, FRAME_ROW_SIZE)
            f.write(row_data)

    spi.close()
    os.close(i2c_fd)

    print("Frame snimljen u image.bin")
