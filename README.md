# ART_GENR8R

My Java-based translation/modification of this Python project: https://jeremykun.com/2012/01/01/random-psychedelic-art/

Here's an example image generated using my version:

![Example](examples/20172901_125548-0800.png)

Written in my free time using [Processing](https://processing.org/) to generate the images. I occasionally run it on my Raspberry Pi and screen at home when I feel like my room needs an aesthetic boost. It will generate a new image every 15 seconds.

![Raspberry Pi](rasbpi.JPG)

The original project took advantage of Python's use of first-class functions to create composite equations. Since Processing uses a version of Java that doesn't support this, I used a Strategy pattern where each function component has its own class implementing a common Operation interface. This means they can be used interchangeably as well as composited. Pretty clever, right? : )
