# black-bear
black bear is an ESP32-based CAN scanner for your car.  

## Purpose
black bear is for diagnosing and pulling information from any car, such as information and faults about the powertrain, steering rack, and more. It is too complicated to get into on a README like this; more infrmation can be found on pages like [OBDSolutions](https://www.obdsol.com/knowledgebase/on-board-diagnostics/what-data-is-available-from-obd/), [SAE J1979](https://legacy.sae.org/standards/), and the [OBD-II PIDs Wikipedia page](https://en.wikipedia.org/wiki/OBD-II_PIDs).  

## Connection
black bear connects to your car's OBD-II port found on every passenger vehicle made after 1996 in the United States. More about OBD-II can be found [here](https://en.wikipedia.org/wiki/On-board_diagnostics#:~:text=OBD%2DIIedit).

## PCB
### Specs
The PCB is designed with JLCPCB standards in mind:
* 2-layer PCB, 1.6mm, FR4, Green
* OSP, HASL, or ENIG coating

Additionally, assembly can be done by JLCPCB PCBA, with the following constraints:
* ESP32 assembly requires Standard PCBA, and not Economic PCBA
* OBD-II port (THT) is not readily available on LCSC/JLCPCB Parts, so you'll have to do that yourself.

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
M3 screws are to be used. There are two options of the top case tray, one for self-tap M3 screws, and one for M3 screws with heatset inserts.
### Images
<details>
<summary>Assembled (collapsable as image is large)</summary>
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