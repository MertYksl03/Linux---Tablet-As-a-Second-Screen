# Tutorial
I just wanted to use my android tablet as a second monitor on linux and it took so many hours to achive that. I read, watched bunch of differant tutorials. It's so complex than I expected.
After figuring it out, I decied to write a tutorial.   
If you are reading this you are probably the same as I was. And i hope this tutorial help you to do it. Then let's get started.    
This tutorial is for especially for **Nvidia users**. But if you have **AMD** or **Intel** graphic card, **I guide you to the right resourses**.      
## My Test Environmennt
- Zorin OS 17.2
- Nvidia RTX 3050 Mobile
- AMD Ryzen 7 5800h with radeon graphics
- Android Tablet(You can use Ipad as well)
  
## Requirements
- ### In the Computer
  - Xorg: If you are using Wayland, this tutorial does not work for you. I have searched a lot and could not find a method that works in Wayland. I think it is impossible in Wayland.
  - A Vnc server(I use x11vnc)   
    To install (Debian-Ubuntu)
```bash
sudo apt install x11vnc
```
- ### In the Tablet
  - A VNC viewer: I use [AVNC](https://play.google.com/store/apps/details?id=com.gaurav.avnc) for android but you can use any other app as well. I don't test it for IOS but I am sure there are VNC clients for IOS. They should work.
## Creating a Virtual Display
I tried [this tutorial](https://github.com/santiagofdezg/linux-extend-screen) but it didn't work for me but I hope it works for you. I think it didn't work because I have a Nvidia GPU.
Then I came across [this](https://github.com/augustoicaro/Immersed-Linux-Virtual-Monitors). I just mixed these two tutorials and it works for me.    

Because I have Nvidia GPU, I am going to explain it for Nvidia cards. If you have a different GPU, you can check [this](https://github.com/augustoicaro/Immersed-Linux-Virtual-Monitors)     

First we need to know if the Xorg config file exist on `/etc/X11/xorg.conf`.     
I don't have one but if you have check [this](https://github.com/augustoicaro/Immersed-Linux-Virtual-Monitors?tab=readme-ov-file#xorgconf-file-exists)    

And then we need to know a name of empty port that the computer has. To know the ports and display we can use this command.
```bash
xrandr
```    
For me the output looks like this. For you, it probably look different(different number of ports, different port names, different resulotions etc.) but it should look similiar.
```bash
Screen 0: minimum 320 x 200, current 3200 x 1080, maximum 16384 x 16384
eDP connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 344mm x 194mm
   1920x1080    144.00*+ 120.00    96.00    72.00    60.00    50.01    48.00    60.00
   1680x1050    144.00
   1280x1024    144.00
   1440x900     144.00
   1280x800     144.00
   1280x720     144.00
   1024x768     144.00
   800x600      144.00
   640x480      144.00
HDMI-1-0 disconnected (normal left inverted right x axis y axis) 
```
As you can see, my laptop has two ports. The eDP port is the main screen of my laptop and the laptop has a disconnected HDMI port named HDMI-1-0. You pick one of the disconnected one(It will be better if it is HDMI) and note that name.    
After that we need to edit the Xorg config file with sudo permission. It located at `/usr/share/X11/xorg.conf.d/10-nvidia.conf` or `/usr/share/X11/xorg.conf.d/nvidia.conf`. The edit you'll need to do is adding the following lines:
```bash
Section "Monitor"
    Identifier     "Monitor0"
    VendorName     "Unknown"
    ModelName      "Unknown"
    Option         "DPMS"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "nvidia"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "ConnectedMonitor" "CHANGE_HERE"
    Option         "ModeValidation" "NoDFPNativeResolutionCheck,NoVirtualSizeCheck,NoMaxPClkCheck,NoHorizSyncCheck,NoVertRefreshCheck,NoWidthAlignmentCheck"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection
```
You need to change the `CHANGE_HERE` string to the port that you choosed and save the file. Then  reboot your laptop or PC. If the port breaks your X server, try another port.     
After rebooting your system, the system should works as usual. To see the result what we did, use the `xrandr` command again. The output should look like this(I removed some of the lines. It was too long):
```bash
Screen 0: minimum 320 x 200, current 3200 x 1080, maximum 16384 x 16384
eDP connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 344mm x 194mm
   1920x1080    144.00*+ 120.00    96.00    72.00    60.00    50.01    48.00    60.00
   1680x1050    144.00
   1280x1024    144.00
   1440x900     144.00
   1280x800     144.00
   1280x720     144.00
   1024x768     144.00
   800x600      144.00
   640x480      144.00
HDMI-1-0 connected 1280x800+1920+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x768      85.00 +  75.03    70.07    60.00    85.00    75.05    60.04
   5120x2880     59.99    59.99
   4096x2304     59.99    59.98
   3840x2160     59.98    59.97    60.01
   3200x1800     59.96    59.94
   2880x1620     59.97    59.96
   2560x1600     59.99    59.97
   2560x1440     59.96    59.95    59.99    59.99
   2048x1536     85.00    75.00    60.00
   2048x1152     59.91    59.90    59.99    59.98
   1920x1440     85.00    75.00    60.00
   1920x1200     59.95    59.88
   1920x1080     59.96    59.93    60.01    59.97
   1856x1392     75.00    60.01
   1792x1344     75.00    60.01
   1680x1050     59.95    59.88
   1600x1200     85.00    75.00    70.00    65.00    60.00
   1600x900      59.95    59.82    59.99    59.94
   1440x810      60.00    59.97
```
If you don't see a particular resulotion that you want to use you can add with these commands:    
- First you need to create a custom mode. You can do that with `cvt` or `gtf`: ``` cvt 1280 800 ```
  The output should look like this:
  ```bash
  1280x800 59.81 Hz (CVT 1.02MA) hsync: 49.70 kHz; pclk: 83.50 MHz
  Modeline "1280x800_60.00"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
  ```
- Then add the mode that you created
  ```bash
  xrandr --newmode "1280x800_60.00"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
  xrandr --addmode HDMI-1-0 "1280x800_60.00"
  ```
Now we can enable the virtual monitor we created by
```bash
xrandr --output HDMI-1-0 --right-of eDP --mode 1280x800_60.00
```
I want the second display is placed at the right side of my main monitor, so I use `--right-of` but you can use `--left-of`. `below` or `above`. You can see your mouse cursor now can go beyond the displays edges.    

It's time to start the VNC server
```bash
x11vnc -clip 1280x800+0+0
```
Now you can connect the server.    

!!! DON NOT FORGET THAT STARTING THE VNC SERVER MEANS ANYONE WHO KNOWS YOUR LOCAL IP ADDRESS IN YOUR LOCAL NETWORK CAN SEE AND CONNECT YOUR VIRTUAL SCREEN!!!    
To prevent that there are some ways. You can check the internet.
## Connecting the VNC Server Wireless (Android and IOS)
To connect the server with your tablet, you need a VNC viewer is installed on your tablet and you need to know the IP addrees of your computer. To find the IP addres you can use:
```bash
ip a 
```
**The defualt port that provied x11vnc is 5900** unless you changed it.     
Enter the IP and the port to VNC app in your tablet and connect your new virtual monitor.
## Connecting via USB (Only Android)
First you need to install 
```bash
sudo apt install adb android-tools-adb android-tools-fastboot
```
Then follow these steps:
- Connect your tablet with your computer via an USB cable
- Turn on the USB debugging in your tablet
  - First enable the developer options by tapping Build Number 7 times in settings(usually located at about page) 
  - Then enable the USB debugging option
- Run the commmand on PC `adb reverse tcp:5900 tcp:5900`
- Enable the second display with the new commands that you learned by this tutorial
- Connect the VNC server with `127.0.0.1` address.
After your job done with your second tablet display don't forget to turn of the ADB daemon:
```bash
adb kill-server
```
# Disabling the Second Display
If your are done using the second screen you can disable it with this command
```bash
xrandr --output HDMI-1-0 --off
```
# For Nvidia Users
Changing the Xorg Nvidia config file results there is always a second display is created when you boot your system eventough you are not intended to use it. It can be so annoying. To prevent that I add the disabling command in my Gnome Startup Applications. I create one when I need it. I recommend that for you. 
