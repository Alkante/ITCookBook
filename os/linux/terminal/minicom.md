# Minicom
Connecteur terminal

## Description Physique

- Protocole    : RS-232
- Connecteur A : DB9 femmal
- Connecteur B : RJ45 male
Connecteur B
```text
(RJ45)
```

Connecteur A : DE9 femmal
```text
  \1 2 3 4 5/
   \6 7 8 9/
```

| Pin number | Acronyme | Nom   | Sens | Description |
|----------- |--------- |------ | ---- |------------ |
| 1 | DCD | Data Carrier Detect | A<-B | Modem connected to another |
| 2 | RxD | Receive Data        | A<-B | Receives bytes into PC |
| 3 | TxD | Transmit Data       | A->B | Transmit bit of out pc |
| 4 | DTR | Data Terminal Ready | A->B | I'm ready to communicate |
| 5 | SG  | Signal Ground       |  -   | GND | RTS/CTS flow control |
| 6 | DSR | Data Carrier Detect | A<-B | I'm ready to communicate |
| 7 | RTS | Request To Send     | A->B | RTS/CTS flow control |
| 8 | CTS | Clear To Send       | A<-B | RTS/CTS flow control |
| 9 | RI  | Ring Indicator      | A<-B | Telephone line ringing |

## Connexion

Exemple : A est un pc DTE (Data Terminal Equipment)et B est un device.

A  pin 2 is labeled RX and is an INPUT the connector is a DTE (Data Terminal Equipment)

B pin 2 is labeled RX and is an OUTPUT the connector is a DCE (Data Computing Equipment)
