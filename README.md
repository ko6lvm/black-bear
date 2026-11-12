# black bear
black bear is an ESP32-based CAN scanner for your car. 

<image src="img/blender/front.png" width=500>

### Purpose
black bear is for diagnosing and pulling information from any car, such as information and faults about the powertrain, steering rack, and more. It is too complicated to get into on a README like this; more information can be found on pages like [OBDSolutions](https://www.obdsol.com/knowledgebase/on-board-diagnostics/what-data-is-available-from-obd/), [SAE J1979](https://legacy.sae.org/standards/), and the [OBD-II PIDs Wikipedia page](https://en.wikipedia.org/wiki/OBD-II_PIDs).  

### Connection
black bear connects to your car's OBD-II port found on every passenger vehicle made after 1996 in the United States. More about OBD-II can be found [here](https://en.wikipedia.org/wiki/On-board_diagnostics#:~:text=OBD%2DIIedit).

## PCB
### Specs
The PCB is designed with JLCPCB standards in mind:
* 2-layer PCB, 1.6mm, FR4, Green
* OSP, HASL, or ENIG coating

Additionally, assembly can be done by JLCPCB PCBA, with the following constraints:
* ESP32 assembly requires Standard PCBA, and not Economic PCBA
* OBD-II port (THT) is not readily available on LCSC/JLCPCB Parts, so you'll have to do that yourself.

### Files

* CPL/BOM files for JLCPCB PCBA is under `pcb/`, marked `_eco.csv` for economic PCBA and `_standard.csv` for standard PCBA.
* Gerber ZIP for both Economic and Standard is at `pcb/black-bear-rev-1.1.zip`.
* KiCAD 10 project files are at `pcb/`, as `bear.kicad_pcb`, `bear.kicad_prl`, `bear.kicad_pro`, and `bear.kicad_sch`.

### Images
<details>
<summary>KiCAD PCB 3D View (collapsable as image is large)</summary>
<image src="img/pcb.png" width=500>
</details>

<details>
<summary>KiCAD PCB Editor View (collapsable as image is large)</summary>
<image src="img/pcb-editor.png" width=700>
</details>

## Schematic
### Images
<details>
<summary>Full Schematic (collapsable as image is large)</summary>
<image src="img/schematic.png" width=700>
</details>

## Case
### Spec
Only use PETG, ABS, or ASA. PLA will deform in a hot car.  
M3 screws are to be used. There are two options of the top case tray, one for self-tap M3 screws, and one for M3 screws with heatset inserts.
### Images
<details>
<summary>Blender Renders (collapsable as image is large)</summary>
<image src="img/blender/front.png" width=700>
<image src="img//blender/bottom.png" width=700>
<image src="img//blender/macro.png" width=700>
<image src="img//blender/exploded.png" width=700>
<image src="img//blender/open.png" width=700>
</details>
<details>
<summary>Renders (collapsable as image is large)</summary>
<image src="img/back-assembled.png" width=700>
<image src="img/front-assembled.png" width=700>
<image src="img/front-bottom-assembled.png" width=700>
<image src="img/top-ortho-assembled.png" width=700>
</details>

<details>
<summary>Case Trays (collapsable as image is large)</summary>
<image src="img/top-heatset.png" width=700>
<image src="img/bottom.png" width=700>
</details>

## Firmware
black bear is not supplied with firmware made specifically for black bear, as there are open-source options that are community-tested and support multiple apps/host software.  [meatpiHQ/wican-fw](https://github.com/meatpihq/wican-fw) is recommended; it supports `elm327` (required for black bear's CAN setup) as well as `slcand` and `gvret` for the host software.

### wican-fw setup
```bash
./fw/edit-wican.sh
cd fw/wican-fw

# Only needed on the very first build
idf.py set-target esp32s3

idf.py -p /dev/ttyACM0 build flash
```

## BoM
Also available at `bom.csv` (csv contains costs). Costs may vary.

| Designator | Qty | Description | Package | MPN | LCSC |
| :--- | :---: | :--- | :--- | :--- | :--- |
| `U1` | 1 | ESP32-S3 Wi-Fi + BLE MCU (8MB Flash) | Module | `ESP32-S3-WROOM-1-N8` | `C2913198` |
| `U2` | 1 | 3.3V CAN Transceiver (1 Mbps) | SOIC-8 | `SN65HVD230DR` | `C12084` |
| `U3` | 1 | 3.3V 600mA LDO Regulator | SOT-23-5 | `AP2112K-3.3TRG1` | `C51118` |
| `U4` | 1 | 3.8–32V to 5V 2A Buck Converter | TSOT-23-6 | `AP63205WU-7` | `C2071056` |
| `D1` | 1 | Dual 24V CAN ESD/TVS Diode | SOT-23 | `NUP2105LT1G` | `C14486` |
| `D2, D3, D4` | 3 | 40V 1A Schottky Diode | SOD-323 | `1N5819WS` | `C191023` |
| `D5` | 1 | 18V 600W Unidirectional TVS Diode | SMB | `SMBJ18A` | `C353379` |
| `F1` | 1 | 30V 500mA Resettable PTC Fuse | 1812 | `JK-MSMD050-30` | `C369168` |
| `L1` | 1 | 4.7µH 6A Shielded Power Inductor | 7.3×6.6mm | `MWSA0603S-4R7MT` | `C408447` |
| `J1` | 1 | OBD-II 16-Pin Male Right-Angle (Hand-Solder) | THT | `CCBDM20` | — |
| `J2` | 1 | USB 2.0 Type-C Receptacle (16P) | SMD+THT | `TYPE-C-31-M-12` | `C165948` |
| `SW1, SW2` | 2 | Tactile Pushbutton Switch (BOOT / RESET) | 5.2×5.2mm | `GT-TZ084B-H015-L1` | `C29780122` |
| `R1` | 1 | 100Ω 1% Resistor | 0603 | `0603WAF1000T5E` | `C22775` |
| `R2, R3` | 2 | 0Ω Jumper | 0603 | `0603WAF0000T5E` | `C21189` |
| `R4` | 1 | 10kΩ 1% Resistor | 0603 | `0603WAF1002T5E` | `C25804` |
| `R5, R6` | 2 | 5.1kΩ 1% Resistor | 0603 | `0603WAF5101T5E` | `C23186` |
| `C1, C4, C5, C9, C10, C13, C14, C15` | 8 | 100nF 50V X7R Capacitor | 0603 | `CC0603KRX7R9BB104` | `C14663` |
| `C6, C7, C16` | 3 | 10µF 25V X5R Capacitor | 0805 | `CL21A106KAYNNNE` | `C15850` |
| `C8` | 1 | 10µF 50V X5R Capacitor | 1206 | `CL31A106KBHNNNE` | `C13585` |
| `C11, C12` | 2 | 22µF 16V X5R Capacitor | 0805 | `CL21A226MOQNNNE` | `C98190` |

Note: `J1` (the OBD-II port) is not usually available from Macchina, so an alternative from other sites such as [this one from eBay](https://www.ebay.com/itm/267812712566) for ~$15 will work as well.