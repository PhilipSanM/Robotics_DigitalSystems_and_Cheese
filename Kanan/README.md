# 🦺KANAN👮

Mexico is one of the most insecure countries, in addition to having a large number of missing persons... Have you ever felt in danger? (This is a project that I carried out during my confinement due to the covid-19 pandemic)<br/>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164563838-89475283-d978-47ea-bd82-54339668a910.jpeg" alt="KANAN1" width="250" height="180"/> </a>

---

## M A I N P R O B L E M.

This project begins in 2020 where the main problem is to combat insecurity in Mexico City, when in 2019 the highest number of cases of disappearances of women and minors was registered (Around 14 cases of disappearances per day).

### WHY KANAN?

With this in mind arises KANAN (KANAN means "little warrior" in Mayan, a pre-Hispanic language of Mexico).

Therefore KANAN, should be a solution that:

<ol>
  <li>Work independently of any other device.</li>
  <li>Be portable.</li>
  <li>Be easy to use.</li>
  <li>Work anywhere.</li>
  <li>Have a low price (Because it is focused on a general public).</li>
  <li>Be light.</li>
  <li>Be difficult to break.</li>
  <li>Have a long battery life.</li>
  <li>Can connect to a database.</li>
</ol>

---

## RESULTS.

KANAN works in such a way that it receives at least one cell phone number of your most trusted contact via text messages or in the code through AT commands (These are the commands that the SIM module understands), and when the battery is full, it is already functional

It has a different appearance to go unnoticed as a help button, then when you press the help button three times, KANAN sends a text message to your close contact of your exact location at that moment using the GPS module. In addition, it sends your exact location to a database, this is because a measure used by the government of Mexico City to curb crime is to divide the city into sectors with a police group in charge for each one sector. Therefore, the reason that the location is also sent anonymously to a database is because it can be implemented so that the government itself can observe the possible cases of assistance in the respective sector, and inform the security secretary of the case to act immediately with the police group of the sector, and this will reduce crime rates at the time they are happening.

<em>Finally, KANAN has the appropriate characteristics so that the population that is most affected (women and minors) can have the device to be able to respond to any act against their safety.</em><br/><br/>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164563965-3ad838b8-a07a-4d22-8c65-764ab32cbec0.jpeg" alt="KANAN1" width="180" height="280"/> </a>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164563991-088ee70a-870b-4e51-9d7e-8eb998011432.PNG" alt="KANAN2" width="180" height="280"/> </a>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164564021-5c723df3-3deb-43fc-ab5f-d0ca08e494e7.jpeg" alt="KANAN3" width="180" height="280"/> </a>

---

## M E T H O D O L O G Y / A P P R O A C H

<strong>The main material to make the device are:</strong>

<strong>-A microcontroller:</strong> In this case I used the [PIC16F873A](https://pdf1.alldatasheet.com/datasheet-pdf/view/82339/MICROCHIP/PIC16F873A.html).<br/>
<strong>-A module GPS: </strong>In this case I used the [neo-6m](https://datasheet4u.com/datasheet-pdf/u-blox/NEO-6M/pdf.php?id=866235).<br/>
<strong>-A module SIM:</strong> In this case I used the [SIM800L](https://datasheet4u.com/datasheet-pdf/SIMCom/SIM800L/pdf.php?id=989664).<br/>
<strong>-A good battery: </strong> Due to the price, KANAN was implemented with AAA batteries, but the perfect battery is: [Lipo](https://www.robotshop.com/eu/en/lipo-battery-1000mah-37v-603050.html).<br/>
<strong>-Others :</strong> leds, diodes, resistors, transistors, etc.
<br/>

**M I C R O C O N T R O L L E R:<br/>**
The microcontroller will be the one guilty of working at the moment the button is pressed, once it is the case, it will read the GPS information, and send the text message to the user's contact and to the DB.<br/><br/>
**G P S .<br/>**
Once the GPS module is connected, it will be sending the information it receives from its antenna repeatedly, the way to handle it is through arrays, but to automate this is the library in my repository. The microcontroller reads the GPS information with the RX pin.<br/><br/>
**S I M.<br/>**
The sim uses AT commands, in such a way that the microcontroller will send those commands and the GPS information through the TX pin, once the information is collected, the module sends the help signal by text message, to the cell phone number of the contact of the user and to the DB.<br/><br/>
**D I G I T A L S Y S T E M S.<br/>**
Finally, this theory is only united with separate circuits that provide the correct power supply and the connection between the modules and the microcontroller.
<br/><br/>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164564259-074006d7-9611-4095-9c53-e3ec8906abf0.jpeg" alt="KANAN4" width="380" height="180"/> </a>
<a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164564723-b4f05da6-94a3-46b5-8ddf-cef7dbf0f8c4.jpeg" alt="KANAN4" width="380" height="180"/> </a>

---

## FUN FACT:

- The name of the project at the begining was: Pingu or SecMate, that's why there are pictures with that name in the schematic, finally i decided to call it just KANAN :)<br/>
  <a  target="_blank"> <img src="https://user-images.githubusercontent.com/99928036/164563630-b8c7e1fa-9b10-47d0-831b-8ea2f99886cb.jpg" alt="pingu" width="95" height="60"/> </a>

**Publication in my Intel DevMesh: [KANAN](https://devmesh.intel.com/projects/kanan-d2e5c2)**
:)
