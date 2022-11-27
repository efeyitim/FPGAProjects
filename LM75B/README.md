In this project LM75B digital temperature sensor is used. Temperature data is read from the sensor using I2C Master module and this data is sent to host machine by UART TX module. Digilent Zybo board is used, received data is monitored using HTerm (screenshot can be seen below).<br/>

[<img src="https://user-images.githubusercontent.com/62470610/204157873-22f229b4-2715-4499-9b9c-b973c3a68eed.jpeg" width="500" height="500"/>](https://user-images.githubusercontent.com/62470610/204157873-22f229b4-2715-4499-9b9c-b973c3a68eed.jpeg)

According to the datasheet of LM75B, first eleven bits read from the sensor are meaningful, and the actual temperature in celsius can be found as multiplying the sensor data by 0.125. Which is (0x138)*0.125 = 39.0C.
[<img src="https://user-images.githubusercontent.com/62470610/204157698-364daecc-5201-422f-8d15-1e56fa58b06f.png" width="800" height="500"/>](https://user-images.githubusercontent.com/62470610/204157698-364daecc-5201-422f-8d15-1e56fa58b06f.png)

