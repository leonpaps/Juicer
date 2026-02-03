# Juicer

This was the plan I concocted in jspaint. 

The idea was to create the juicer with 2d graphics.

![plan](./plan.png)

What i ended up with:

<p align="center" width="100%">
<video src="https://github.com/user-attachments/assets/850ce543-5972-49a6-b161-071d52522f7d" width="80%" controls></video>
</p>


This is my first time using ruby2d

Things I struggled with:
 - debugging collisions
 - keeping the codebase clean as I went
 - slicing an orange in 2 and having the segments actually behave


**Note:** MacOS has not been tested.
https://www.ruby2d.com/learn/get-started/


### Dependencies
On linux there are dependencies to install the gem.

### Linux

    sudo apt install libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev


    sudo yum install SDL2-devel SDL2_image-devel SDL2_mixer-devel SDL2_ttf-devel

    sudo zypper install libSDL2-devel libSDL2_image-devel libSDL2_mixer-devel libSDL2_ttf-devel

    sudo pacman -S sdl2 sdl2_image sdl2_mixer sdl2_ttf

    

### Ruby Gem

Install the Ruby2D gem:

`gem install ruby2d`

Running the App
---------------

Simply run:

ruby juice.rb

