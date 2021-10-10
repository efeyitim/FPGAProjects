In this project, I have tried some of the foundation techniques of the image processing like mirroring, reversing, adjusting brightness and contrast. The test scenario is as follows: gather a 8-bit gray-scaled image whose dimensions are 256 by 256 and write it to the block-ram. Later, the FPGA will read it from the block ram and apply the techniques to the image. Results will be saved to separate txt files and converted to the images later using MATLAB scripts that I also added to the GitHub. You can see the results below:

Original Image:\
![cameraman](https://user-images.githubusercontent.com/62470610/136695831-a5b3bece-fb6d-4442-8731-32c51f67b5ae.jpg)

Mirror:\
![cameraman_mirror](https://user-images.githubusercontent.com/62470610/136695855-7d75daee-ce7e-47d0-8926-6a7eb043aa4b.jpg)

Reverse:\
![cameraman_reverse](https://user-images.githubusercontent.com/62470610/136695854-785e7082-b341-4feb-942a-f53b8fbea27b.jpg)

Negative:\
![cameraman_negative](https://user-images.githubusercontent.com/62470610/136695858-0590e549-b4c2-4caf-a19b-feef5483688f.jpg)

Threshold:\
![cameraman_threshold](https://user-images.githubusercontent.com/62470610/136695860-2e9bd142-2ec9-48a5-afae-2896da514903.jpg)

Brightness Up and Down:\
![cameraman_brightnessup](https://user-images.githubusercontent.com/62470610/136695863-fd5cadfc-c574-4507-8de7-69032b3f9c47.jpg)
![cameraman_brightnessdown](https://user-images.githubusercontent.com/62470610/136695866-80cb385d-10e7-4241-8a92-f842c43dab0f.jpg)

Contrast Up and Down:\
![cameraman_contrastup](https://user-images.githubusercontent.com/62470610/136695868-17074b11-f900-4986-a6cf-f1609ccc2b47.jpg)
![cameraman_contrastdown](https://user-images.githubusercontent.com/62470610/136695871-5fcff320-e2cb-4e8c-a5fa-ad5892e58532.jpg)
