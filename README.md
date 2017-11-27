# Fruit-Tracker
Identifies fruit in a video and tracks it, displaying its movement

Allows for a user to hold up a fruit and move it around, showing the fruit's movement on the screen
#### Fruit Currently Identified
* Apple




## Algorithms Used
Mean-shift tracking is used to track the fruit.  A color histogram from a circular window is created to model the object.
Adaptive scale is also used, allowing the object to be tracked as it's size increases and decreases due to its distance to the camera.

## NOTE
Currently, the identification part is not implemented.  The user must manually input the location and size of the fruit.
