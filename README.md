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
* Gerber ZIP for both Economic and Standard is at `pcb/black-bear-rev-1.2.zip`.
* KiCAD 10 project files are at `pcb/`, as `bear.kicad_pcb`, `bear.kicad_prl`, `bear.kicad_pro`, and `bear.kicad_sch`.
* KiCAD 10 library files are at `pcb/lib/`.

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
### Specs
Only use PETG, ABS, or ASA. PLA will deform in a hot car.  
M3 screws are to be used. There are two options of the top case tray, one for self-tap M3 screws, and one for M3 screws with heatset inserts.
### Images
<details>
<summary>Renders (collapsable as image is large)</summary>
<image src="img/blender/front.png" width=700>
<image src="img/blender/bottom.png" width=700>
<image src="img/blender/macro.png" width=700>
<image src="img/blender/exploded.png" width=700>
<image src="img/blender/open.png" width=700>
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
bash ./fw/edit-wican.sh
cd fw/wican-fw

# Only needed on the very first build
idf.py set-target esp32s3

idf.py -p /dev/ttyACM0 build flash
```

## BoM
Also available at `bom.csv` (csv contains costs). Costs may vary.

| Designator | Qty | Value | Description | Package | Manufacturer | MPN | Link |
| :--- | :---: | :--- | :--- | :--- | :--- | :--- | :--- |
| `U1` | 1 | `ESP32-S3-WROOM-1-N8` | ESP32-S3 Wi-Fi + BLE MCU (8MB Flash) | Module | Espressif Systems | `ESP32-S3-WROOM-1-N8` | [C2913198](https://jlcpcb.com/partdetail/C2913198) |
| `U2` | 1 | `SN65HVD230` | 3.3V CAN Transceiver (1 Mbps) | SOIC-8 | Texas Instruments | `SN65HVD230DR` | [C12084](https://jlcpcb.com/partdetail/C12084) |
| `U3` | 1 | `AP2112K-3.3` | 3.3V 600mA LDO Regulator | SOT-23-5 | Diodes Incorporated | `AP2112K-3.3TRG1` | [C51118](https://jlcpcb.com/partdetail/C51118) |
| `U4` | 1 | `AP63205WU` | 3.8-32V to 5V 2A Buck Converter | TSOT-23-6 | Diodes Incorporated | `AP63205WU-7` | [C2071056](https://jlcpcb.com/partdetail/C2071056) |
| `D1` | 1 | `NUP2105L` | Dual 24V CAN ESD/TVS Diode | SOT-23 | onsemi | `NUP2105LT1G` | [C14486](https://jlcpcb.com/partdetail/C14486) |
| `D2, D3, D4` | 3 | `1N5819WS` | 40V 1A Schottky Diode | SOD-323 | Guangdong Hottech | `1N5819WS` | [C191023](https://jlcpcb.com/partdetail/C191023) |
| `D5` | 1 | `SMBJ18A` | 18V 600W Unidirectional TVS Diode | SMB | MDD | `SMBJ18A` | [C353379](https://jlcpcb.com/partdetail/C353379) |
| `F1` | 1 | `500mA` | 30V 500mA Resettable PTC Fuse | 1812 | Jinrui | `JK-MSMD050-30` | [C369168](https://jlcpcb.com/partdetail/C369168) |
| `L1` | 1 | `4.7uH` | 4.7uH 6A Shielded Power Inductor | 7.3x6.6mm | Sunlord | `MWSA0603S-4R7MT` | [C408447](https://jlcpcb.com/partdetail/C408447) |
| `J1` | 1 | `CCBDM20` | OBD-II 16-Pin Male Right-Angle (Hand-Solder) | THT | Generic | `CCBDM20` | [eBay](https://www.ebay.com/itm/307150583236) |
| `J2` | 1 | `TYPE-C-31-M-12` | USB 2.0 Type-C Receptacle (16P) | SMD+THT | Korean Hroparts Elec | `TYPE-C-31-M-12` | [C165948](https://jlcpcb.com/partdetail/C165948) |
| `SW1, SW2` | 2 | `GT-TZ084B-H015-L1` | Tactile Pushbutton Switch (BOOT / RESET) | 5.2x5.2mm | G-Switch | `GT-TZ084B-H015-L1` | [C29780122](https://jlcpcb.com/partdetail/C29780122) |
| `R1` | 1 | `100R` | 100 Ohm 1% Resistor | 0603 | UNI-ROYAL | `0603WAF1000T5E` | [C22775](https://jlcpcb.com/partdetail/C22775) |
| `R2, R3` | 2 | `0R` | 0 Ohm Jumper | 0603 | UNI-ROYAL | `0603WAF0000T5E` | [C21189](https://jlcpcb.com/partdetail/C21189) |
| `R4, R9` | 2 | `10k` | 10 kOhm 1% Resistor | 0603 | UNI-ROYAL | `0603WAF1002T5E` | [C25804](https://jlcpcb.com/partdetail/C25804) |
| `R5, R6` | 2 | `5.1k` | 5.1 kOhm 1% Resistor | 0603 | UNI-ROYAL | `0603WAF5101T5E` | [C23186](https://jlcpcb.com/partdetail/C23186) |
| `R7` | 1 | `100k` | 100 kOhm 1% Resistor | 0603 | UNI-ROYAL | `0603WAF1003T5E` | [C25803](https://jlcpcb.com/partdetail/C25803) |
| `R8` | 1 | `16k` | 16 kOhm 1% Resistor | 0603 | UNI-ROYAL | `0603WAF1602T5E` | [C4210](https://jlcpcb.com/partdetail/C4210) |
| `C4, C9, C10, C13, C14, C15, C17` | 7 | `100nF` | 100nF 50V X7R Capacitor | 0603 | Yageo | `CC0603KRX7R9BB104` | [C14663](https://jlcpcb.com/partdetail/C14663) |
| `C5` | 1 | `1uF` | 1uF 50V X5R Capacitor | 0603 | Samsung Electro-Mechanics | `CL10A105KB8NNNC` | [C15849](https://jlcpcb.com/partdetail/C15849) |
| `C6, C7, C16` | 3 | `10uF` | 10uF 25V X5R Capacitor | 0805 | Samsung Electro-Mechanics | `CL21A106KAYNNNE` | [C15850](https://jlcpcb.com/partdetail/C15850) |
| `C8` | 1 | `10uF` | 10uF 50V X5R Capacitor | 1206 | Samsung Electro-Mechanics | `CL31A106KBHNNNE` | [C13585](https://jlcpcb.com/partdetail/C13585) |
| `C11, C12` | 2 | `22uF` | 22uF 16V X5R Capacitor | 0805 | Samsung Electro-Mechanics | `CL21A226MOQNNNE` | [C98190](https://jlcpcb.com/partdetail/C98190) |

Note: `J1` (the OBD-II port) is not usually available from Macchina, so an alternative from other sites such as [this one from eBay](https://www.ebay.com/itm/307150583236) for ~$15 will work as well.