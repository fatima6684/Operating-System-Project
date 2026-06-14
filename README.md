# XV6 Network Stack & E1000 Driver

### Operating Systems Course Project

## 📌 Overview

This project extends **xv6** by implementing a network subsystem and a driver for the **Intel 82540EM Gigabit Ethernet Controller (E1000)** device.

The network card is emulated using **QEMU** with user-mode networking (SLIRP). The project focuses on building the complete packet transmission and reception path inside the kernel, including Ethernet, IP, and UDP processing.

---

## 🎯 Objectives

* Implement a hardware network driver inside the xv6 kernel
* Handle TX/RX descriptor rings and DMA
* Integrate packet processing into the network stack
* Implement user-level UDP communication
* Understand kernel-level networking design

---

## ⚙️ Main Components

### 🔹 E1000 Driver (kernel/e1000.c)

* Transmit (TX) and Receive (RX) ring management
* DMA buffer handling
* Interrupt-driven packet reception
* Memory-mapped register interaction
* Proper buffer allocation and freeing

### 🔹 Network Stack (kernel/net.c)

* Ethernet frame handling
* IP packet processing
* UDP packet parsing and dispatching

### 🔹 System Calls

Implementation of:

* `bind()`
* `unbind()`
* `send()`
* `recv()`

Features include:

* Port-based packet queues (max 16 packets per port)
* Safe memory management
* Correct byte-order handling (`ntohl`, `ntohs`)

---

## 🧪 Testing

* Packet capture via `packets.pcap`
* Inspection using `tcpdump` or **Wireshark**
* Verification of correct TX/RX behavior and UDP delivery

---

## 📂 Repository Structure

```
kernel/
 ├── e1000.c
 ├── e1000_dev.h
 ├── net.c
 ├── net.h
```

---

## 👥 Contributors

* [**Matin Bagheri**](https://github.com/MatinB02)
* [**Fatima Timarchi**](https://github.com/fatima6684)
* [**Ayeh Saberi**](https://github.com/AyehSaberi84)
* [**Hoora Abedin**](https://github.com/hoora-abedin)

---

## 🏁 Summary

This project provides hands-on experience with kernel-level driver development, interrupt handling, DMA, and network protocol implementation inside an operating system.
